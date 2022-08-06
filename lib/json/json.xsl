<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="../codegen/codegen.xsl"/>


    <!-- Serializing names -->

    <xsl:template match="node()" mode="xat.json.allowedName">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:function name="xat:json.allowedName">
        <xsl:param name="str"/>
        <xsl:apply-templates select="$str" mode="xat.json.allowedName"/>
    </xsl:function>

    <xsl:template match="node()[self::text()]" mode="xat.json.propName">
        <xsl:value-of select="'#'"/>
    </xsl:template>

    <xsl:template match="@*" mode="xat.json.propName">
        <xsl:value-of select="concat('@', xat:json.allowedName(name()))"/>
    </xsl:template>

    <xsl:template match="*" mode="xat.json.propName">
        <xsl:value-of select="xat:json.allowedName(name())"/>
    </xsl:template>

    <xsl:function name="xat:json.propName">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.json.propName"/>
    </xsl:function>

    <xsl:template match="@*" mode="xat.json.wppName">
        <xsl:text>attr</xsl:text>
    </xsl:template>

    <xsl:template match="node()[self::text()]" mode="xat.json.wppName">
        <xsl:text>text</xsl:text>
    </xsl:template>

    <xsl:template match="*" mode="xat.json.wppName">
        <xsl:text>element</xsl:text>
    </xsl:template>

    <xsl:function name="xat:json.wppName">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.json.wppName"/>
    </xsl:function>

    <xsl:template match="node() | @*" mode="xat.json.wcpName">
        <xsl:text>content</xsl:text>
    </xsl:template>

    <xsl:function name="xat:json.wcpName">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.json.wcpName"/>
    </xsl:function>


    <!-- Serializing values -->

    <xsl:function name="xat:json.escapeAtomicValue">
        <xsl:param name="val"/>

        <xsl:variable name="esc">
            <esc regexp="&quot;" escaped="\&quot;"/>
            <esc regexp="\\" escaped="\\"/>
            <esc regexp="\t" escaped="\t"/>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.escapeExplicit($val, $esc)"/>

    </xsl:function>

    <xsl:function name="xat:json.atomicValueTypeName">
        <xsl:param name="val"/>

        <xsl:choose>
            <xsl:when test="matches($val, '^(true|false)$')">
                <xsl:text>boolean</xsl:text>
            </xsl:when>
            <xsl:when test="matches($val, '^((\+|-)?)(\d+)((\.\d+)?)$')">
                <xsl:text>number</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>string</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <xsl:template match="node() | @*" mode="xat.json.atomicValue">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:function name="xat:json.atomicValue">
        <xsl:param name="node"/>

        <xsl:variable name="rawVal">
            <xsl:apply-templates select="$node" mode="xat.json.atomicValue"/>
        </xsl:variable>

        <xsl:variable name="typeName" select="xat:json.atomicValueTypeName($rawVal)"/>

        <xsl:choose>
            <xsl:when test="$typeName = ('boolean', 'number')">
                <xsl:value-of select="$rawVal"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="xat:codegen.quote(xat:json.escapeAtomicValue($rawVal))"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <xsl:function name="xat:json.prop">
        <xsl:param name="name"/>
        <xsl:param name="val"/>
        <xsl:value-of select="concat(xat:codegen.quote($name), ': ', $val)"/>
    </xsl:function>

    <xsl:function name="xat:json.monome">
        <xsl:param name="name"/>
        <xsl:param name="content"/>

        <xsl:value-of select="xat:codegen.braces(xat:json.prop($name, $content))"/>

    </xsl:function>

    <xsl:function name="xat:json.binome">
        <xsl:param name="name1"/>
        <xsl:param name="content1"/>
        <xsl:param name="name2"/>
        <xsl:param name="content2"/>

        <xsl:variable name="prop1" select="xat:json.prop($name1, $content1)"/>
        <xsl:variable name="prop2" select="xat:json.prop($name2, $content2)"/>

        <xsl:value-of select="xat:codegen.braces(xat:codegen.list(($prop1, $prop2)))"/>

    </xsl:function>


    <!-- Detecting useful nodes -->

    <xsl:template match="node()" mode="xat.json.isUseful" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="node()[self::text()]" mode="xat.json.isUseful" as="xs:boolean">
        <xsl:sequence select="normalize-space(.) != ''"/>
    </xsl:template>

    <xsl:template match="(*[name() != ''] | @*)" mode="xat.json.isUseful" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:json.isUseful" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.json.isUseful"/>
    </xsl:function>


    <!-- Serializing atoms -->

    <xsl:template match="node()" mode="xat.json.isAtom" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="node()[self::text()]" mode="xat.json.isAtom" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="@*" mode="xat.json.isAtom" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[name() != '']" mode="xat.json.isAtom" as="xs:boolean">
        <xsl:sequence select="not(exists((* | @*)[xat:json.isUseful(.)]))"/>
    </xsl:template>

    <xsl:function name="xat:json.isAtom" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.json.isAtom"/>
    </xsl:function>

    <xsl:template match="node() | @*" mode="xat.json.atom">
        <xsl:value-of select="xat:json.atomicValue(.)"/>
    </xsl:template>


    <!-- Serializing objects -->

    <xsl:template match="@*" mode="xat.json.isObject" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="xat.json.isObject" as="xs:boolean">
        <xsl:variable name="childrenNames" as="xs:string*">
            <xsl:copy-of select="(node() | @*)[xat:json.isUseful(.)]/xat:json.propName(.)"/>
        </xsl:variable>
        <xsl:variable name="countUniqueChildrenNames">
            <xsl:value-of select="count(distinct-values($childrenNames))"/>
        </xsl:variable>
        <xsl:variable name="countChildren">
            <xsl:value-of select="count(node() | @*[xat:json.isUseful(.)])"/>
        </xsl:variable>
        <xsl:sequence select="$countChildren = $countUniqueChildrenNames"/>
    </xsl:template>

    <xsl:function name="xat:json.isObject" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.json.isObject"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.json.object">

        <xsl:variable name="props" as="xs:string*">
            <!--
            <xsl:apply-templates select="(node() | @*)[xat:json.isUseful(.)]" mode="xat.json.pulp"/>
            -->
            
            <xsl:for-each select="(node() | @*)[xat:json.isUseful(.)]">
                <xsl:value-of select="xat:json.prop(xat:json.propName(.), xat:json.pulp(.))"/>
            </xsl:for-each>
            
        </xsl:variable>

        <xsl:value-of select="xat:codegen.braces(xat:codegen.list($props))"/>

    </xsl:template>


    <!-- Serializing arrays -->

    <xsl:template match="*" mode="xat.json.array">

        <xsl:variable name="elements" as="xs:string*">
            <!--
            <xsl:apply-templates select="(node() | @*)[xat:json.isUseful(.)]" mode="xat.json.pulp"/>
            -->
            
            <xsl:for-each select="(node() | @*)[xat:json.isUseful(.)]">
                <xsl:value-of select="xat:json.monome(xat:json.propName(.), xat:json.pulp(.))"/>
            </xsl:for-each>
           
        </xsl:variable>

        <xsl:value-of select="xat:codegen.brackets(xat:codegen.list($elements))"/>

    </xsl:template>

    <xsl:template match="*" mode="xat.json.isUniform" as="xs:boolean">
        <xsl:variable name="childrenNames" as="xs:string*">
            <xsl:copy-of select="node()[xat:json.isUseful(.)]/xat:json.propName(.)"/>
        </xsl:variable>
        <xsl:variable name="countUniqueChildrenNames">
            <xsl:value-of select="count(distinct-values($childrenNames))"/>
        </xsl:variable>
        <xsl:variable name="countUsefulAttrs">
            <xsl:value-of select="count(@*[xat:json.isUseful(.)])"/>
        </xsl:variable>
        <!--
        <xsl:sequence select="$countUniqueChildrenNames = 1 and $countUsefulAttrs = 0"/>
        -->
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:function name="xat:json.isUniform" as="xs:boolean">
        <xsl:param name="arrayElement"/>
        <xsl:apply-templates select="$arrayElement" mode="xat.json.isUniform"/>
    </xsl:function>

    <xsl:template match="*[xat:json.isUniform(.)]" mode="xat.json.array">

        <xsl:variable name="elements" as="xs:string*">
            <xsl:apply-templates select="(node() | @*)[xat:json.isUseful(.)]" mode="xat.json.pulp"/>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.brackets(xat:codegen.list($elements))"/>

    </xsl:template>


    <!-- Generic transform -->

    <xsl:template match="node() | @*" mode="xat.json.pulp">
        <xsl:choose>
            <xsl:when test="xat:json.isAtom(.)">
                <xsl:apply-templates select="." mode="xat.json.atom"/>
            </xsl:when>
            <xsl:when test="xat:json.isObject(.)">
                <xsl:apply-templates select="." mode="xat.json.object"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="xat.json.array"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:function name="xat:json.pulp">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.json.pulp"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.json">
        <xsl:value-of select="xat:json.monome(xat:json.propName(.), xat:json.pulp(.))"/>
    </xsl:template>

    <xsl:function name="xat:json">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.json"/>
    </xsl:function>

</xsl:stylesheet>
