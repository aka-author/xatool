<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     uriserialize.xsl
    Usage:      Guts    
    Func:       Serializing URI
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- file: -->
    <xsl:template match="protocol" mode="cpm.uri.serialize">
        <xsl:value-of select="."/>
        <xsl:text>:</xsl:text>
    </xsl:template>

    <!-- file: -->
    <xsl:template match="protocol" mode="cpm.uri.section">
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- qwerty -->
    <xsl:template match="password" mode="cpm.uri.serialize">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- //qwerty -->
    <xsl:template match="password" mode="cpm.uri.section">
        <xsl:text>//</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- daRKlOrD-->
    <xsl:template match="login" mode="cpm.uri.serialize">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- :daRKlOrD -->
    <xsl:template match="login[preceding-sibling::password]" mode="cpm.uri.section">
        <xsl:text>:</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- //daRKlOrD -->
    <xsl:template match="login[not(preceding-sibling::password)]" mode="cpm.uri.section">
        <xsl:text>//</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- www.philosoft.ru -->
    <xsl:template match="host" mode="cpm.uri.serialize">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- //www.philosoft.ru -->
    <xsl:template match="host[not(preceding-sibling::login)]" mode="cpm.uri.section">
        <xsl:text>//</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- @www.philosoft.ru -->
    <xsl:template match="host[preceding-sibling::login]" mode="cpm.uri.section">
        <xsl:text>@</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- 8080 -->
    <xsl:template match="port" mode="cpm.uri.serialize">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- :8080 -->
    <xsl:template match="port" mode="cpm.uri.section">
        <xsl:text>:</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- c: -->
    <xsl:template match="drive" mode="cpm.uri.serialize">
        <xsl:value-of select="."/>
        <xsl:text>:</xsl:text>
    </xsl:template>

    <!-- /c: -->
    <xsl:template match="drive" mode="cpm.uri.section">
        <xsl:text>/</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- wombat.xhtml -->
    <xsl:template match="folder | file" mode="cpm.uri.serialize">
        <xsl:value-of select="base"/>
        <xsl:if test="type">
            <xsl:text>.</xsl:text>
            <xsl:value-of select="type"/>
        </xsl:if>
    </xsl:template>

    <!-- /wombat.xhtml -->
    <xsl:template match="folder | file" mode="cpm.uri.section">
        <xsl:text>/</xsl:text>
        <xsl:apply-templates select="." mode="cpm.uri.serialize"/>
    </xsl:template>

    <!-- A template-->
    <xsl:template match="uri" mode="cpm.uri.serialize">
        <xsl:apply-templates select="*" mode="cpm.uri.section"/>
    </xsl:template>

    <!-- Any URI or a part of an URI -->
    <xsl:function name="cpm:uri.serialize">
        <xsl:param name="xmlItem"/>
        <xsl:variable name="tmp">
            <xsl:choose>
                <xsl:when test="name($xmlItem) = ''">
                    <xsl:apply-templates select="$xmlItem/*" mode="cpm.uri.serialize"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$xmlItem" mode="cpm.uri.serialize"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$tmp"/>
    </xsl:function>

</xsl:stylesheet>
