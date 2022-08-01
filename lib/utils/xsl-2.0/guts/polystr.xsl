<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     polystr.xsl
    Usage:      Guts    
    Func:       Providing custom normalization for strings
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- 
        Modules 
    -->

    <!-- Transliteration -->
    <xsl:import href="translit.xsl"/>


    <!-- 
        Normalizing strings
    -->

    <xsl:template match="*[@mode = 'hashtag']" mode="cpm.polystr.normalize">
        <xsl:variable name="strNoise">
            <xsl:text><![CDATA[ `~!?@#$%^&*()_+=,.:;[]{}<>'"\/|]]></xsl:text>
        </xsl:variable>
        <xsl:value-of select="normalize-space(upper-case(translate(@string, $strNoise, '')))"/>
    </xsl:template>

    <xsl:template match="*[@mode = 'spaceCASE']" mode="cpm.polystr.normalize">
        <xsl:value-of select="normalize-space(upper-case(@string))"/>
    </xsl:template>

    <xsl:template match="*[@mode = 'spacecase']" mode="cpm.polystr.normalize">
        <xsl:value-of select="normalize-space(lower-case(@string))"/>
    </xsl:template>

    <xsl:template match="*[@mode = 'CASE']" mode="cpm.polystr.normalize">
        <xsl:value-of select="upper-case(@string)"/>
    </xsl:template>

    <xsl:template match="*[@mode = 'case']" mode="cpm.polystr.normalize">
        <xsl:value-of select="lower-case(@string)"/>
    </xsl:template>

    <xsl:template match="*[@mode = 'space']" mode="cpm.polystr.normalize">
        <xsl:value-of select="normalize-space(@string)"/>
    </xsl:template>

    <xsl:template match="*[@mode = ('', 'asis')]" mode="cpm.polystr.normalize">
        <xsl:value-of select="@string"/>
    </xsl:template>

    <xsl:function name="cpm:polystr.normalize">
        <xsl:param name="strItem"/>
        <xsl:param name="strMode"/>
        <xsl:variable name="xmlData">
            <data string="{$strItem}" mode="{$strMode}"/>
        </xsl:variable>
        <xsl:apply-templates select="$xmlData/data" mode="cpm.polystr.normalize"/>
    </xsl:function>


    <!-- 
        Processing strings using normalization
    -->

    <!-- Comparing normalized strings -->
    <xsl:function name="cpm:polystr.equal" as="xs:boolean">
        <xsl:param name="strItem1"/>
        <xsl:param name="strItem2"/>
        <xsl:param name="strMode"/>
        <xsl:variable name="strNorm1" select="cpm:polystr.normalize($strItem1, $strMode)"/>
        <xsl:variable name="strNorm2" select="cpm:polystr.normalize($strItem2, $strMode)"/>
        <xsl:value-of select="$strNorm1 = $strNorm2"/>
    </xsl:function>

    <!-- Normalizing a sequence of strings -->
    <xsl:function name="cpm:polystr.normseq" as="xs:string*">
        <xsl:param name="seqItems" as="xs:string*"/>
        <xsl:param name="strNorm"/>
        <xsl:for-each select="$seqItems">
            <xsl:value-of select="cpm:polystr.normalize(., $strNorm)"/>
        </xsl:for-each>
    </xsl:function>

</xsl:stylesheet>
