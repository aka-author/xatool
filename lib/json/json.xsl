<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="../codegen/codegen.xsl"/>


    <!-- Serializing names -->

    <xsl:template match="node()[exists(self::text())]" mode="xat.json.propName">
        <xsl:value-of select="'textContent'"/>
    </xsl:template>

    <xsl:template match="* | @*" mode="xat.json.propName">
        <xsl:value-of select="translate(name(), ':-', '__')"/>
    </xsl:template>

    <xsl:function name="xat:json.propName">
        <xsl:param name="node"/>

        <xsl:variable name="rawName">
            <xsl:apply-templates select="$node" mode="xat.json.propName"/>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.quote($rawName)"/>

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
        <xsl:value-of select="concat($name, ': ', $val)"/>
    </xsl:function>


    <!-- Detecting useful nodes -->

    <xsl:template match="node()" mode="xat.json.isUseful" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="node()[self::text()]" mode="xat.json.isUseful" as="xs:boolean">
        <xsl:sequence select="normalize-space(.) != ''"/>
    </xsl:template>

    <xsl:template match="(* | @*)[name() != '']" mode="xat.json.isUseful" as="xs:boolean">
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

    <xsl:template match="*" mode="xat.json.isObject" as="xs:boolean">
        <xsl:variable name="childrenNames" as="xs:string*">
            <xsl:copy-of select="node()[xat:json.isUseful(.)]/xat:json.propName(.)"/>
        </xsl:variable>
        <xsl:variable name="countUniqueChildrenNames">
            <xsl:value-of select="count(distinct-values($childrenNames))"/>
        </xsl:variable>
        <xsl:variable name="countChildren">
            <xsl:copy-of select="count(node()[xat:json.isUseful(.)])"/>
        </xsl:variable>
        <xsl:sequence select="$countChildren = $countUniqueChildrenNames"/>
    </xsl:template>

    <xsl:function name="xat:json.isObject" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.json.isObject"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.json.object">

        <xsl:variable name="props" as="xs:string*">
            <xsl:for-each select="(node() | @*)[xat:json.isUseful(.)]">
                <xsl:value-of select="xat:json.prop(xat:json.propName(.), xat:json(.))"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.braces(xat:codegen.list($props))"/>

    </xsl:template>


    <!-- Serializing arrays -->

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
        <xsl:sequence select="$countUniqueChildrenNames = 1 and $countUsefulAttrs = 0"/>
    </xsl:template>

    <xsl:function name="xat:json.isUniform" as="xs:boolean">
        <xsl:param name="arrayElement"/>
        <xsl:apply-templates select="$arrayElement" mode="xat.json.isUniform"/>
    </xsl:function>

    <xsl:template match="@* | node()" mode="xat.json.ae">

        <xsl:variable name="propNameName" select="xat:json.propName('property')"/>
        <xsl:variable name="propNameValue" select="xat:json.atomicValue(name())"/>
        <xsl:variable name="propName" select="xat:json.prop($propNameName, $propNameValue)"/>

        <xsl:variable name="propContentName" select="xat:json.propName('content')"/>
        <xsl:variable name="propContentValue">
            <xsl:apply-templates select="." mode="xat.json"/>
        </xsl:variable>
        <xsl:variable name="propContent" select="xat:json.prop($propContentName, $propContentValue)"/>

        <xsl:variable name="inner" select="xat:codegen.list(($propName, $propContent))"/>
        <xsl:value-of select="xat:codegen.braces($inner)"/>

    </xsl:template>

    <xsl:template match="*" mode="xat.json.array">

        <xsl:variable name="elements" as="xs:string*">
            <xsl:choose>
                <xsl:when test="xat:json.isUniform(.)">
                    <xsl:apply-templates select="(@* | node())[xat:json.isUseful(.)]" mode="xat.json"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="(@* | node())[xat:json.isUseful(.)]" mode="xat.json.ae"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.brackets(xat:codegen.list($elements))"/>

    </xsl:template>


    <!-- Generic transform -->

    <xsl:template match="node() | @*" mode="xat.json">
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

    <xsl:function name="xat:json">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.json"/>
    </xsl:function>

</xsl:stylesheet>
