<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:import href="../../common/xsl-2.0/common.xsl"/>
    <xsl:import href="../../refmerge/xsl-2.0/refmerge.xsl"/>


    <xsl:function name="xat:xon.load">
        <xsl:param name="uriXonFile"/>
        <xsl:apply-templates select="document($uriXonFile)/*" mode="xat.refmerge"/>
    </xsl:function>

    <xsl:function name="xat:xon.splitPath" as="xs:string*">
        <xsl:param name="path"/>
        <xsl:copy-of select="tokenize($path, '\.')"/>
    </xsl:function>

    <xsl:function name="xat:xon.propertyPath">
        <xsl:param name="recordPath"/>
        <xsl:param name="propertyName"/>
        <xsl:value-of select="concat($recordPath, '.', $propertyName)"/>
    </xsl:function>

    <xsl:function name="xat:xon.joinPath">
        <xsl:param name="names" as="xs:string*"/>
        <xsl:value-of select="string-join($names, '.')"/>
    </xsl:function>
    
    <xsl:function name="xat:xon.pathTail" as="xs:string*">
        <xsl:param name="path"/>
        <xsl:variable name="names" as="xs:string*">
            <xsl:copy-of select="xat:xon.splitPath($path)[position() &gt; 1]"/>
        </xsl:variable>
        <xsl:value-of select="xat:xon.joinPath($names)"/>
    </xsl:function>

    <xsl:function name="xat:xon.parentPath">
        <xsl:param name="path"/>
        <xsl:value-of select="xat:xon.joinPath(xat:xon.splitPath($path)[position() &lt; last()])"/>
    </xsl:function>

    <xsl:function name="xat:xon.propertyName">
        <xsl:param name="path"/>
        <xsl:value-of select="xat:xon.splitPath($path)[last()]"/>
    </xsl:function>

    <xsl:function name="xat:xon.isRoot" as="xs:boolean">
        <xsl:param name="item"/>
        <xsl:sequence select="not(exists($item/parent::*))"/>
    </xsl:function>

    <xsl:template match="*[xat:xon.isRoot(.) and @name]" mode="xat.xon.name">
        <xsl:value-of select="@name"/>
    </xsl:template>

    <xsl:template match="*[xat:xon.isRoot(.) and not(@name)]" mode="xat.xon.name"/>

    <xsl:template match="record/*[@name]" mode="xat.xon.name">
        <xsl:value-of select="@name"/>
    </xsl:template>

    <xsl:template match="record/*[not(@name)]" mode="xat.xon.name">
        <xsl:value-of select="xat:id(.)"/>
    </xsl:template>

    <xsl:template match="array/*" mode="xat.xon.name">
        <xsl:value-of select="count(preceding-sibling::*) + 1"/>
    </xsl:template>

    <xsl:function name="xat:xon.name">
        <xsl:param name="item"/>
        <xsl:apply-templates select="$item" mode="xat.xon.name"/>
    </xsl:function>

    <xsl:function name="xat:xon.hasName" as="xs:boolean">
        <xsl:param name="item"/>
        <xsl:sequence select="xat:xon.name($item) != ''"/>
    </xsl:function>

    <xsl:template match="record[xat:xon.hasName(.)]/*" mode="xat.xon.path">
        <xsl:value-of select="concat(xat:xon.path(..), '.', xat:xon.name(.))"/>
    </xsl:template>

    <xsl:template match="array/*" mode="xat.xon.path">
        <xsl:value-of select="concat(xat:xon.path(..), '[', xat:xon.name(.), ']')"/>
    </xsl:template>

    <xsl:template match="*[not(xat:xon.hasName(.))]/*" mode="xat.xon.path">
        <xsl:value-of select="xat:xon.name(.)"/>
    </xsl:template>

    <xsl:template match="*[xat:xon.isRoot(.) and xat:xon.hasName(.)]" mode="xat.xon.path">
        <xsl:value-of select="xat:xon.name(.)"/>
    </xsl:template>

    <xsl:function name="xat:xon.path">
        <xsl:param name="item"/>
        <xsl:apply-templates select="$item" mode="xat.xon.path"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.xon.metaAttr">
        <xsl:param name="attrName"/>
        <xsl:value-of select="@*[name() = $attrName]"/>
    </xsl:template>
    
    <xsl:function name="xat:xon.metaAttr">
        <xsl:param name="xon"/>
        <xsl:param name="path"/>
        <xsl:param name="attrName"/>
        <xsl:apply-templates select="$xon//*[xat:xon.path(.) = $path]" mode="xat.xon.metaAttr">
            <xsl:with-param name="attrName" select="$attrName"/>
        </xsl:apply-templates>
    </xsl:function>
    
    <xsl:function name="xat:xon.mutability">
        <xsl:param name="xon"/>
        <xsl:param name="path"/>
        <xsl:value-of select="xat:xon.metaAttr($xon, $path, 'mutability')"/>
    </xsl:function>
    
    <xsl:function name="xat:xon.alias">
        <xsl:param name="xon"/>
        <xsl:param name="path"/>
        <xsl:value-of select="xat:xon.metaAttr($xon, $path, 'alias')"/>
    </xsl:function>
    
    <xsl:template match="property" mode="xat.xon.content">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="property[@content]" mode="xat.xon.content">
        <xsl:value-of select="@content"/>
    </xsl:template>

    <xsl:function name="xat:xon.content">
        <xsl:param name="prop"/>
        <xsl:apply-templates select="$prop" mode="xat.xon.content"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.xon">
        <xsl:param name="path"/>
        <xsl:value-of select="xat:xon.content(//*[xat:xon.path(.) = $path])"/>
    </xsl:template>

    <xsl:function name="xat:xon">
        <xsl:param name="xon"/>
        <xsl:param name="path"/>
        <xsl:apply-templates select="$xon/*" mode="xat.xon">
            <xsl:with-param name="path" select="$path"/>
        </xsl:apply-templates>
    </xsl:function>

    <xsl:template match="/*[not(@name)] | array/*" mode="xat.xon.laconicName">
        <xsl:value-of select="name()"/>
    </xsl:template>

    <xsl:template match="/*[@name] | record/*[@name]" mode="xat.xon.laconicName">
        <xsl:value-of select="@name"/>
    </xsl:template>

    <xsl:template match="record/*[not(@name)]" mode="xat.xon.laconicName">
        <xsl:value-of select="name()"/>
    </xsl:template>

    <xsl:function name="xat:xon.laconicName">
        <xsl:param name="item"/>
        <xsl:apply-templates select="$item" mode="xat.xon.laconicName"/>
    </xsl:function>

    <xsl:template match="property" mode="xat.xon.laconic">
        <xsl:element name="{xat:xon.laconicName(.)}">
            <xsl:value-of select="xat:xon.content(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="array | record" mode="xat.xon.laconic">
        <xsl:element name="{xat:xon.laconicName(.)}">
            <xsl:apply-templates select="*" mode="#current"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
