<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="../../codegen/xsl-2.0/codegen.xsl"/>


    <!-- Serializing names -->

    <xsl:template match="node()[self::text()]" mode="xat:json.propName">
        <xsl:value-of select="'#'"/>
    </xsl:template>

    <xsl:template match="@*" mode="xat:json.propName">
        <xsl:value-of select="concat('@', name())"/>
    </xsl:template>

    <xsl:template match="*" mode="xat:json.propName">
        <xsl:value-of select="name()"/>
    </xsl:template>

    <xsl:function name="xat:json.propName">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat:json.propName"/>
    </xsl:function>


    <!-- Serializing values -->

    <xsl:function name="xat:json.escapeAtomicValue">
        <xsl:param name="val"/>

        <xsl:variable name="esc">
            <esc regexp="&quot;" escaped="\&quot;"/>
            <esc regexp="\\" escaped="\\"/>
            <esc regexp="\t" escaped="\t"/>
            <esc regexp="\n" escaped="\n"/>
            <esc regexp="\r" escaped="\r"/>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.escapeExplicit($val, $esc)"/>

    </xsl:function>

    <xsl:template match="text()" mode="xat:json.atomicValueTypeName">
        <xsl:text>string</xsl:text>
    </xsl:template>

    <xsl:template match="text()[matches(., '^(true|false)$')]" mode="xat:json.atomicValueTypeName">
        <xsl:text>boolean</xsl:text>
    </xsl:template>

    <xsl:template match="text()[matches(., '^((\+|-)?)(\d+)((\.\d+)?)$')]"
        mode="xat:json.atomicValueTypeName">
        <xsl:text>number</xsl:text>
    </xsl:template>

    <xsl:function name="xat:json.atomicValueTypeName">
        <xsl:param name="val"/>
        <xsl:apply-templates select="$val" mode="xat:json.atomicValueTypeName"/>
    </xsl:function>

    <xsl:template match="node() | @*" mode="xat:json.atomicValue">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:function name="xat:json.atomicValue">
        <xsl:param name="node"/>

        <xsl:variable name="rawVal">
            <xsl:apply-templates select="$node" mode="xat:json.atomicValue"/>
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


    <!-- Detecting useful nodes -->

    <xsl:template match="node()" mode="xat:json.isUseful" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="node()[self::text()]" mode="xat:json.isUseful" as="xs:boolean">
        <xsl:sequence select="normalize-space(.) != ''"/>
    </xsl:template>

    <xsl:template match="*[name() != ''] | @*" mode="xat:json.isUseful" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:json.isUseful" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat:json.isUseful"/> 
    </xsl:function>


    <!-- Serializing atoms -->

    <xsl:template match="node()" mode="xat:json.isAtom" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="node()[self::text()]" mode="xat:json.isAtom" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="@*" mode="xat:json.isAtom" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:template match="*[name() != '']" mode="xat:json.isAtom" as="xs:boolean">
        <xsl:sequence select="not(exists((* | @*)[xat:json.isUseful(.)]))"/>
    </xsl:template>

    <xsl:function name="xat:json.isAtom" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat:json.isAtom"/> 
    </xsl:function>

    <xsl:template match="node() | @*" mode="xat:json.atom">
        <xsl:value-of select="xat:json.atomicValue(.)"/>
    </xsl:template>


    <!-- Serializing objects -->

    <xsl:template match="node()[self::text()] | @*" mode="xat:json.asObject" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="xat:json.asObject" as="xs:boolean">

        <xsl:variable name="childrenNames" as="xs:string*">
            <xsl:copy-of select="(node() | @*)[xat:json.isUseful(.)]/xat:json.propName(.)"/>
        </xsl:variable>
        <xsl:variable name="countUniqueChildrenNames">
            <xsl:value-of select="count(distinct-values($childrenNames))"/>
        </xsl:variable>
        <xsl:variable name="countChildren">
            <xsl:value-of select="count((node() | @*)[xat:json.isUseful(.)])"/>
        </xsl:variable>

        <xsl:sequence select="$countChildren = $countUniqueChildrenNames"/>

    </xsl:template>

    <xsl:function name="xat:json.asObject" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat:json.asObject"/> 
    </xsl:function>

    <xsl:template match="node()[self::text()] | @*" mode="xat:json.isObject" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*" mode="xat:json.isObject" as="xs:boolean">
        <xsl:choose>
            <xsl:when test="xat:json.asObject(.)">
                <xsl:variable name="n" select="name()"/>
                <xsl:value-of select="not(exists(//*[name() = $n and not(xat:json.asObject(.))]))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="xat:json.isObject" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat:json.isObject"/>
    </xsl:function>

    <xsl:template match="*" mode="xat:json.object">

        <xsl:variable name="props" as="xs:string*">
            <xsl:for-each-group select="(node() | @*)[xat:json.isUseful(.)]"
                group-by="xat:json.propName(.)">
                <xsl:variable name="name" select="current-grouping-key()"/>
                <xsl:variable name="pulp" select="xat:json.pulp(current-group()[1])"/>
                <xsl:value-of select="xat:json.prop($name, $pulp)"/>
            </xsl:for-each-group>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.braces(xat:codegen.list($props))"/>

    </xsl:template>


    <!-- Serializing arrays -->

    <xsl:template match="*" mode="xat:json.isUniform" as="xs:boolean">
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
        <xsl:apply-templates select="$arrayElement" mode="xat:json.isUniform"/>
    </xsl:function>

    <xsl:template match="*" mode="xat:json.array">

        <xsl:variable name="elements" as="xs:string*">
            <xsl:for-each select="(node() | @*)[xat:json.isUseful(.)]">
                <xsl:value-of select="xat:json.monome(xat:json.propName(.), xat:json.pulp(.))"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="xat:codegen.brackets(xat:codegen.list($elements))"/>

    </xsl:template>


    <!-- Generic transform -->

    <xsl:template match="node() | @*" mode="xat:json.pulp">
        <xsl:choose>
            <xsl:when test="xat:json.isAtom(.)">
                <xsl:apply-templates select="." mode="xat:json.atom"/>
            </xsl:when>
            <xsl:when test="xat:json.isObject(.)">
                <xsl:apply-templates select="." mode="xat:json.object"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="xat:json.array"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="xat:json.pulp">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat:json.pulp"/>
    </xsl:function>

    <xsl:template match="*" mode="xat:json">
        <xsl:value-of select="xat:json.monome(xat:json.propName(.), xat:json.pulp(.))"/>
    </xsl:template>

    <xsl:function name="xat:json">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat:json"/>
    </xsl:function>
    
    <xsl:function name="xat:json.var">
        <xsl:param name="varName"/>
        <xsl:param name="element"/>
        <xsl:value-of select="concat('var ', $varName, '=', xat:json($element), ';')"/>
    </xsl:function>

</xsl:stylesheet>
