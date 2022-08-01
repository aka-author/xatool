<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     strlists.xsl
    Usage:      Guts    
    Func:       Processing lists that are represented by strings
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Custom normalization for strings -->
    <xsl:import href="polystr.xsl"/>

    <!-- Fast selectors etc. -->
    <xsl:import href="doitquick.xsl"/>


    <!-- 
        Parsing list pattern string:   
    -->

    <!-- 
        Both item and separator patterns:         '[A-Za-z]+ \s*(,|;)\s*'
        An item pattern; separators don't matter: '[A-Za-z]+ .+'
        A separator pattern; item don't matter:   '\s*(,|;)\s*'
        A default separator is provided:          '[A-Za-z]+ \s*(,|;)\s* e.g. ,\s'     
    -->

    <!-- Extracting an item pattern, e.g. cpmitem: [A-Za-z][A-Za-z\d]* -->
    <xsl:function name="cpm:strlist.itmPattern">
        <xsl:param name="strPatterns"/>

        <xsl:variable name="seqParts" select="tokenize(normalize-space($strPatterns), '\s+')"/>

        <xsl:choose>
            <xsl:when test="count($seqParts) = 4">
                <xsl:value-of select="$seqParts[1]"/>
            </xsl:when>
            <xsl:when test="count($seqParts) = 2">
                <xsl:value-of select="$seqParts[1]"/>
            </xsl:when>
        </xsl:choose>
       
    </xsl:function>

    <!-- Extracting a separator pattern, e.g. cpmsep: \s*,\s* -->
    <xsl:function name="cpm:strlist.sepPattern">
        <xsl:param name="strPatterns"/>

        <xsl:variable name="seqParts" select="tokenize(normalize-space($strPatterns), '\s+')"/>

        <xsl:choose>
            <xsl:when test="count($seqParts) = 1">
                <xsl:value-of select="$seqParts[1]"/>
            </xsl:when>
            <xsl:when test="count($seqParts) = 2">
                <xsl:value-of select="$seqParts[2]"/>
            </xsl:when>
            <xsl:when test="count($seqParts) = 3">
                <xsl:value-of select="$seqParts[1]"/>
            </xsl:when>
            <xsl:when test="count($seqParts) = 4">
                <xsl:value-of select="$seqParts[2]"/>
            </xsl:when>
        </xsl:choose>
        
    </xsl:function>

    <!-- Extracting a default separator list separator -->
    <xsl:function name="cpm:strlist.defSep">
        <xsl:param name="strPatterns"/>

        <xsl:variable name="seqParts" select="tokenize(normalize-space($strPatterns), '\s+')"/>

        <xsl:variable name="strRawDefSep">
            <xsl:choose>
                <xsl:when test="count($seqParts) = 3">
                    <xsl:value-of select="$seqParts[3]"/>
                </xsl:when>
                <xsl:when test="count($seqParts) = 4">
                    <xsl:value-of select="$seqParts[4]"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="tmp">
            <xsl:analyze-string select="$strRawDefSep" regex="\\s|\\\\">
                <xsl:matching-substring>
                    <xsl:choose>
                        <xsl:when test=". = '\s'">
                            <xsl:text>&#32;</xsl:text>
                        </xsl:when>
                        <xsl:when test=". = '\\'">
                            <xsl:text>\</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:value-of select="$tmp"/>

    </xsl:function>
    
    <!-- Suggesting an separator for a list -->
    <xsl:function name="cpm:strlist.separ">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        
        <xsl:variable name="strItmPattern" select="cpm:strlist.itmPattern($strPatterns)"/>
        <xsl:variable name="strSepPattern" select="cpm:strlist.sepPattern($strPatterns)"/>
        
        <xsl:variable name="seqSeps" as="xs:string*">
            <xsl:choose>
                
                <xsl:when test="$strSepPattern != ''">
                    <xsl:analyze-string select="$strList" regex="{$strSepPattern}">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:analyze-string select="$strList" regex="{$strItmPattern}">
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:otherwise>
                
            </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="cpm:diq.strDef($seqSeps[1], cpm:strlist.defSep($strPatterns))"/>
        
    </xsl:function>
    
    <!-- Suggesting an separator for a couple of list -->
    <xsl:function name="cpm:strlist.separ2">
        <xsl:param name="strList1"/>
        <xsl:param name="strList2"/>
        <xsl:param name="strPatterns"/>
        
        <xsl:variable name="strSep1" select="cpm:strlist.separ($strList1, $strPatterns)"/>
        
        <xsl:choose>
            <xsl:when test="$strSep1 != ''">
                <xsl:value-of select="$strSep1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="cpm:strlist.separ($strList2, $strPatterns)"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>


    <!-- 
        Unpacking a string to a sequence of string items    
    -->
    
    <!-- Splitting a list using patterns like -->
    <xsl:function name="cpm:strlist.sequence" as="xs:string*">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>

        <xsl:variable name="strItmPattern" select="cpm:strlist.itmPattern($strPatterns)"/>
        <xsl:variable name="strSepPattern" select="cpm:strlist.sepPattern($strPatterns)"/>

        <xsl:choose>

            <xsl:when test="$strItmPattern != ''">
                <xsl:analyze-string select="$strList" regex="{$strItmPattern}">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>

            <xsl:when test="$strSepPattern != ''">
                <xsl:copy-of select="tokenize($strList, $strSepPattern)"/>
            </xsl:when>

        </xsl:choose>

    </xsl:function>

    
    <!-- 
        Serializing a sequence to a list
    -->

    <xsl:function name="cpm:strlist.string">
        <xsl:param name="strList" as="xs:string*"/>
        <xsl:param name="strSep"/>
        <xsl:value-of select="string-join($strList, $strSep)"/>
    </xsl:function>


    <!-- 
        Assembling lists
    -->

    <!-- 'cow, horse' and 'cat, dog' give 'cow, horse, cat, dog' -->
    <xsl:function name="cpm:strlist.append">
        <xsl:param name="strList1"/>
        <xsl:param name="strList2"/>
        <xsl:param name="strPatterns"/>
        <xsl:variable name="strSep" select="cpm:strlist.separ2($strList1, $strList1, $strPatterns)"/>
        <xsl:value-of select="concat($strList1, $strSep, $strList2)"/>
    </xsl:function>


    <!-- 
        Processing lists
    -->

    <!-- Reassembling a list with another separator -->
    <xsl:function name="cpm:strlist.chsep">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNewSep"/>
        <xsl:variable name="seqList" select="cpm:strlist.sequence($strList, $strPatterns)"/>
        <xsl:value-of select="cpm:strlist.string($seqList, $strNewSep)"/>
    </xsl:function>

    <!-- Transforming a list to a normalized sequence -->
    <xsl:function name="cpm:strlist.normseq" as="xs:string*">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>
        <xsl:variable name="seqList" select="cpm:strlist.sequence($strList, $strPatterns)"
            as="xs:string*"/>
        <xsl:copy-of select="cpm:polystr.normseq($seqList, $strNorm)"/>
    </xsl:function>

    <!-- 'cow, horse, rabbit' gives 'cow' -->
    <xsl:function name="cpm:strlist.head">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:value-of select="cpm:strlist.sequence($strList, $strPatterns)[1]"/>
    </xsl:function>

    <!-- 'cow, horse, rabbit' gives 'horse, rabbit' -->
    <xsl:function name="cpm:strlist.tail" as="xs:string">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:variable name="seqList" select="cpm:strlist.sequence($strList, $strPatterns)"/>
        <xsl:variable name="strSep" select="cpm:strlist.separ($strList, $strPatterns)"/>
        <xsl:value-of select="cpm:strlist.string($seqList[position() != 1], $strSep)"/>
    </xsl:function>


    <!-- 
        Testing lists
    -->

    <!-- Detecting the number of list items -->
    <xsl:function name="cpm:strlist.count">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:value-of select="count(cpm:strlist.sequence($strList, $strPatterns))"/>
    </xsl:function>

    <!-- Detecting empty lists -->
    <xsl:function name="cpm:strlist.isEmpty" as="xs:boolean">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:value-of select="cpm:strlist.count($strList, $strPatterns) = 0"/>
    </xsl:function>

    <!-- Does a list contain an item? -->
    <xsl:function name="cpm:strlist.contains" as="xs:boolean">
        <xsl:param name="strList"/>
        <xsl:param name="strItem"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>

        <xsl:variable name="strNormItem" select="cpm:polystr.normalize($strItem, $strNorm)"/>

        <xsl:variable name="seqNormList" as="xs:string*">
            <xsl:for-each select="cpm:strlist.sequence($strList, $strPatterns)">
                <xsl:value-of select="cpm:polystr.normalize(., $strNorm)"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="$strNormItem = $seqNormList"/>

    </xsl:function>

</xsl:stylesheet>
