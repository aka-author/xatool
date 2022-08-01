<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     encoding.xsl    
    Usage:      Guts
    Func:       Working with symbol encoding
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    xmlns:java-urldecode="java:java.net.URLDecoder" exclude-result-prefixes="cpm java-urldecode xs"
    version="2.0">

    <!-- 
         Unicode
    -->

    <!-- Replacing codes like %20 with corresponding Unicode characters -->
    <xsl:function name="cpm:encoding.decodeURI">
        <xsl:param name="strItem"/>
        <xsl:value-of select="java-urldecode:decode($strItem, 'UTF-8')"/>
    </xsl:function>


    <!-- 
        ASCII
    -->

    <!-- A list of ASCII characters -->
    <xsl:function name="cpm:encoding.strASCII">
        <xsl:variable name="strASCII">
            <xsl:text><![CDATA[&#00;&#01;&#02;&#03;&#04;&#05;&#06;&#07;&#08;&#09;]]></xsl:text>
            <xsl:text><![CDATA[&#10;&#11;&#12;&#13;&#14;&#15;&#16;&#17;&#18;&#19;]]></xsl:text>
            <xsl:text><![CDATA[&#20;&#21;&#22;&#23;&#24;&#25;&#26;&#27;&#29;&#29;]]></xsl:text>
            <xsl:text><![CDATA[&#30;&#21;]]></xsl:text>
            <xsl:text><![CDATA[ !"#$%&'()*+,-./0123456789:;<=>?@]]></xsl:text>
            <xsl:text><![CDATA[ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`]]></xsl:text>
            <xsl:text><![CDATA[abcdefghijklmnopqrstuvwxyz{|}~]]></xsl:text>
        </xsl:variable>
        <xsl:value-of select="$strASCII"/>
    </xsl:function>

    <!-- Removing ASCII characters from a string -->
    <xsl:function name="cpm:encoding.removeASCII">
        <xsl:param name="strItem"/>
        <xsl:value-of select="translate($strItem, cpm:encoding.strASCII(), '')"/>
    </xsl:function>

    <!-- Detecting ASCII characters -->
    <xsl:function name="cpm:encoding.isASCII" as="xs:boolean">
        <xsl:param name="chrItem"/>
        <xsl:value-of select="contains(cpm:encoding.strASCII(), $chrItem)"/>
    </xsl:function>


    <!-- 
        Detecting Unicode ranges
    -->

    <!-- Does a character match a range? -->
    <xsl:function name="cpm:encoding.match" as="xs:boolean">
        <xsl:param name="chrA"/>
        <xsl:param name="chrX"/>
        <xsl:param name="chrZ"/>
        <xsl:value-of select="compare($chrA, $chrX) != 1 and compare($chrX, $chrZ) != 1"/>
    </xsl:function>

    <!-- A Unicode range is undefined by default -->
    <xsl:template match="*" mode="cpm.encoding.range">
        <xsl:text>Undefined</xsl:text>
    </xsl:template>

    <!-- Basic Latin -->
    <xsl:template match="*[contains(cpm:encoding.strASCII(), .)]" mode="cpm.encoding.range">
        <xsl:text>Latin</xsl:text>
    </xsl:template>

    <!-- C1 Controls and Latin-1 Supplement -->
    <xsl:template match="*[cpm:encoding.match('&#x0080;', ., '&#x00FF;')]" mode="cpm.encoding.range">
        <xsl:text>Latin1</xsl:text>
    </xsl:template>

    <!-- Latin Extended-A -->
    <xsl:template match="*[cpm:encoding.match('&#x0100;', ., '&#x017F;')]" mode="cpm.encoding.range">
        <xsl:text>LatinA</xsl:text>
    </xsl:template>

    <!-- Latin Extended-B -->
    <xsl:template match="*[cpm:encoding.match('&#x0180;', ., '&#x024F;')]" mode="cpm.encoding.range">
        <xsl:text>LatinB</xsl:text>
    </xsl:template>

    <!-- Greek/Coptic -->
    <xsl:template match="*[cpm:encoding.match('&#x0370;', ., '&#x03FF;')]" mode="cpm.encoding.range">
        <xsl:text>Greek</xsl:text>
    </xsl:template>

    <!-- Cyrillic -->
    <xsl:template match="*[cpm:encoding.match('&#x0400;', ., '&#x04FF;')]" mode="cpm.encoding.range">
        <xsl:text>Cyrillic</xsl:text>
    </xsl:template>

    <!-- Hebrew -->
    <xsl:template match="*[cpm:encoding.match('&#x0590;', ., '&#x05FF;')]" mode="cpm.encoding.range">
        <xsl:text>Hebrew</xsl:text>
    </xsl:template>

    <!-- Detecting a Unicode range for a character -->
    <xsl:function name="cpm:encoding.range">
        <xsl:param name="chrItem"/>
        <xsl:variable name="xmlChar">
            <char>
                <xsl:value-of select="$chrItem"/>
            </char>
        </xsl:variable>
        <xsl:apply-templates select="$xmlChar/char" mode="cpm.encoding.range"/>
    </xsl:function>

    <!-- Detecting a Unicode range for a string -->
    <xsl:function name="cpm:encoding.strRange">
        <xsl:param name="strItem"/>
        <xsl:variable name="strNonASCII" select="cpm:encoding.removeASCII($strItem)"/>
        <xsl:choose>
            <xsl:when test="$strNonASCII = ''">
                <xsl:text>Latin</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="cpm:encoding.range(substring($strNonASCII, 1, 1))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Representing a string as a sequence of characters -->
    <xsl:function name="cpm:encoding.sequence" as="xs:string*">
        <xsl:param name="strItem"/>
        <xsl:analyze-string select="$strItem" regex=".">
            <xsl:matching-substring>
                <xsl:value-of select="."/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>

</xsl:stylesheet>
