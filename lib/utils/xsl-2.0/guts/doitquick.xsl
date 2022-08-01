<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     doitquick.xsl
    Usage:      Guts    
    Func:       Using simple calls instead of a few code lines 
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs"
    version="2.0">
    
    <!-- 
        Selectors
    -->
    
    <!-- Returning a default string instead of empty one -->
    <xsl:function name="cpm:diq.strDef">
        <xsl:param name="strItem"/>
        <xsl:param name="strDefaultItem"/>
        <xsl:choose>
            <xsl:when test="$strItem != ''">
                <xsl:value-of select="$strItem"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$strDefaultItem"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Returning a default number instead of zero -->
    <xsl:function name="cpm:diq.numDef" as="xs:decimal">
        <xsl:param name="numItem" as="xs:decimal"/>
        <xsl:param name="numDefaultItem" as="xs:decimal"/>
        <xsl:choose>
            <xsl:when test="$numItem != 0">
                <xsl:value-of select="$numItem"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$numDefaultItem"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Selecting a string value -->
    <xsl:function name="cpm:diq.strIif">
        <xsl:param name="blnSwitcher" as="xs:boolean"/>
        <xsl:param name="strTrueItem"/>
        <xsl:param name="strFalseItem"/>
        <xsl:choose>
            <xsl:when test="$blnSwitcher">
                <xsl:value-of select="$strTrueItem"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$strFalseItem"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>