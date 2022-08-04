<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     strsets.xsl
    Usage:      Guts    
    Func:       Processing sets that are represented by strings
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- 
        Modules 
    -->

    <!-- Processing lists that are represented by strings -->
    <xsl:import href="strlist.xsl"/>


    <!-- 
        Assembling sets
    -->

    <!-- Making a set from a list -->
    <xsl:function name="xat:strset.set">
        <xsl:param name="strList"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>

        <xsl:variable name="seqList" as="xs:string*">
            <xsl:copy-of select="xat:strlist.sequence($strList, $strPatterns)"/>
        </xsl:variable>

        <xsl:variable name="seqNormList" as="xs:string*">
            <xsl:copy-of select="xat:strlist.normseq($strList, $strPatterns, $strNorm)"/>
        </xsl:variable>

        <xsl:variable name="seqSet" as="xs:string*">
            <xsl:for-each select="distinct-values($seqNormList)">
                <xsl:value-of select="($seqList[xat:polystr.equal(., current(), $strNorm)])[1]"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="strSep" select="xat:strlist.separ($strList, $strPatterns)"/>

        <xsl:value-of select="xat:strlist.string($seqSet, $strSep)"/>

    </xsl:function>

    <!-- 'cow, horse' and 'cow, rabbit' give 'cow, horse, rabbit' -->
    <xsl:function name="xat:strset.union">
        <xsl:param name="strSet1"/>
        <xsl:param name="strSet2"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>
        <xsl:variable name="strList" select="xat:strlist.append($strSet1, $strSet2, $strPatterns)"/>
        <xsl:value-of select="xat:strset.set($strList, $strPatterns, $strNorm)"/>
    </xsl:function>

    <!-- 'cow, horse' and 'cow, rabbit' give 'cow' -->
    <xsl:function name="xat:strset.intersection">
        <xsl:param name="strSet1"/>
        <xsl:param name="strSet2"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>
        <xsl:variable name="seqSet1" select="xat:strlist.sequence($strSet1, $strPatterns)"
            as="xs:string*"/>
        <xsl:variable name="seqNormSet2"
            select="xat:strlist.normseq($strSet2, $strPatterns, $strNorm)" as="xs:string*"/>
        <xsl:variable name="seqIntersection" as="xs:string*">
            <xsl:for-each select="$seqSet1">
                <xsl:if test="xat:polystr.normalize(., $strNorm) = $seqNormSet2">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="strSep" select="xat:strlist.separ($strSet1, $strPatterns)"/>
        <xsl:value-of select="xat:strlist.string($seqIntersection, $strSep)"/>
    </xsl:function>

    <!-- 'cow, horse' and 'cow, rabbit' give 'horse' -->
    <xsl:function name="xat:strset.difference">
        <xsl:param name="strSet1"/>
        <xsl:param name="strSet2"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>
        <xsl:variable name="seqSet1" select="xat:strlist.sequence($strSet1, $strPatterns)"
            as="xs:string*"/>
        <xsl:variable name="seqNormSet2"
            select="xat:strlist.normseq($strSet2, $strPatterns, $strNorm)" as="xs:string*"/>
        <xsl:variable name="seqDifference" as="xs:string*">
            <xsl:for-each select="$seqSet1">
                <xsl:if test="not(xat:polystr.normalize(., $strNorm) = $seqNormSet2)">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="strSep" select="xat:strlist.separ($strSet1, $strPatterns)"/>
        <xsl:value-of select="xat:strlist.string($seqDifference, $strSep)"/>
    </xsl:function>


    <!-- 
        Comparing sets
    -->

    <!-- Are two sets equivalent? -->
    <xsl:function name="xat:strset.equal" as="xs:boolean">
        <xsl:param name="strSet1"/>
        <xsl:param name="strSet2"/>
        <xsl:param name="strPatterns"/>
        <xsl:param name="strNorm"/>
        <xsl:variable name="strDiff1"
            select="xat:strset.difference($strSet1, $strSet2, $strPatterns, $strNorm)"/>
        <xsl:variable name="strDiff2"
            select="xat:strset.difference($strSet2, $strSet1, $strPatterns, $strNorm)"/>
        <xsl:value-of select="$strDiff1 = '' and $strDiff2 = ''"/>
    </xsl:function>

</xsl:stylesheet>
