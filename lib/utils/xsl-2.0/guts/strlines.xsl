<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     strlines.xsl
    Usage:      Guts    
    Func:       Splitting a text into lines
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">


    <!-- Making a line -->

    <xsl:function name="xat:strln.win">
        <xsl:param name="str"/>
        <xsl:value-of select="concat($str, '&#13;&#10;')"/>
    </xsl:function>
    
    <xsl:function name="xat:strln.ux">
        <xsl:param name="str"/>
        <xsl:value-of select="concat($str, '&#10;')"/>
    </xsl:function>
    

    <!-- 
        Splitting a text into lines
    -->

    <!-- Detecting a line terminator -->
    <xsl:function name="xat:strlines.terminator">
        <xsl:param name="strText"/>
        <xsl:text>&#x0D;&#x0A;|&#x0D;|&#x0A;|&#x0085;|&#x0085;|&#x2020;|&#x2029;</xsl:text>
    </xsl:function>

    <!-- Filtering a seqence of strings by a negative pattern -->
    <xsl:function name="xat:strlines.filterExclude" as="xs:string*">
        <xsl:param name="seqLines" as="xs:string*"/>
        <xsl:param name="strExcludePattern"/>
        <xsl:choose>
            <xsl:when test="$strExcludePattern != ''">
                <xsl:copy-of select="$seqLines[not(matches(., $strExcludePattern))]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$seqLines"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Filtering a seqence of strings by a positive pattern -->
    <xsl:function name="xat:strlines.filterInclude" as="xs:string*">
        <xsl:param name="seqLines" as="xs:string*"/>
        <xsl:param name="strIncludePattern"/>
        <xsl:if test="$strIncludePattern != ''">
            <xsl:copy-of select="$seqLines[matches(., $strIncludePattern)]"/>
        </xsl:if>
    </xsl:function>

    <!-- Splitting a text by lines and exclude redundant lines -->
    <xsl:function name="xat:strlines.splitExclude" as="xs:string*">
        <xsl:param name="strText"/>
        <xsl:param name="strExcludePattern"/>

        <xsl:variable name="strLineTerminator">
            <xsl:value-of select="xat:strlines.terminator($strText)"/>
        </xsl:variable>

        <xsl:variable name="seqRawLines" as="xs:string*">
            <xsl:copy-of select="tokenize($strText, $strLineTerminator)"/>
        </xsl:variable>

        <xsl:copy-of select="xat:strlines.filterExclude($seqRawLines, $strExcludePattern)"/>

    </xsl:function>

    <!-- Splitting a text by lines and include appropriate lines -->
    <xsl:function name="xat:strlines.splitInclude" as="xs:string*">
        <xsl:param name="strText"/>
        <xsl:param name="strIncludePattern"/>

        <xsl:variable name="strLineTerminator">
            <xsl:value-of select="xat:strlines.terminator($strText)"/>
        </xsl:variable>

        <xsl:variable name="seqRawLines" as="xs:string*">
            <xsl:copy-of select="tokenize($strText, $strLineTerminator)"/>
        </xsl:variable>

        <xsl:copy-of select="xat:strlines.filterInclude($seqRawLines, $strIncludePattern)"/>

    </xsl:function>

</xsl:stylesheet>
