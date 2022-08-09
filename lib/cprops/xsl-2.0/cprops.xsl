<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:import href="../../refmerge/xsl-2.0/refmerge.xsl"/>


    <xsl:function name="xat:cprops.load">
        <xsl:param name="uriCprops"/>
        <xsl:apply-templates select="document($uriCprops)/*" mode="xat.refmerge"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.cprops.localName">
        <xsl:value-of select="@name"/>
    </xsl:template>
    
    <xsl:function name="xat:cprops.localName">
        <xsl:param name="item"/>
        <xsl:apply-templates select="$item" mode="xat.cprops.localName"/>
    </xsl:function>

    <xsl:template match="prop" mode="xat.cprops.content">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="prop[@content]" mode="xat.cprops.content">
        <xsl:value-of select="@content"/>
    </xsl:template>

    <xsl:function name="xat:cprops.content">
        <xsl:param name="prop"/>
        <xsl:apply-templates select="$prop" mode="xat.cprops.content"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.cprops.local">
        <xsl:param name="propName"/>
    </xsl:template>

    <xsl:template match="record" mode="xat.cprops.local">
        <xsl:param name="name"/>
        <xsl:value-of select="xat:cprops.content(prop[xat:cprops.localName(.) = $name])"/>
    </xsl:template>

    <xsl:function name="xat:cprops.local">
        <xsl:param name="record"/>
        <xsl:apply-templates select="$record" mode="xat.cprops.local"/>
    </xsl:function>

    <xsl:template match="record" mode="xat.cprops.localName">
        <xsl:value-of select="xat:cprops.local('name')"/>
    </xsl:template>

    <xsl:template match="/*/*" mode="xat:cprops.fullName">
        <xsl:value-of select="xat:cprops.localName(.)"/>
    </xsl:template>

    <xsl:template match="*[exists(..)]" mode="xat.cprops.fullName">
        <xsl:value-of select="xat:cprops.fullName(..), '.', xat:cprops.localName(.)"/>
    </xsl:template>

    <xsl:function name="xat:cprops.fullName">
        <xsl:param name="item"/>
        <xsl:apply-templates select="$item" mode="xat.cprops.fullName"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.cprops">
        <xsl:param name="fullName"/>
        <xsl:value-of select="xat:cprops.content(//*[xat:cprops.fullName(.) = $fullName])"/>
    </xsl:template>

    <xsl:function name="xat:cprops">
        <xsl:param name="fullName"/>
        <xsl:param name="cprops"/>
        <xsl:apply-templates select="$cprops/*" mode="xat.cprops">
            <xsl:with-param name="fullName" select="$fullName"/>
        </xsl:apply-templates>
    </xsl:function>

</xsl:stylesheet>