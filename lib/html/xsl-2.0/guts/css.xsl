<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:function name="xat:css.prop">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:value-of select="concat($name, ': ', $value)"/>
    </xsl:function>

    <xsl:function name="xat:css.var">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:variable name="prefix">
            <xsl:if test="not(starts-with($name, '--'))">
                <xsl:value-of select="'--'"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="xat:css.prop(concat($prefix, $name), $value)"/>
    </xsl:function>

    <xsl:function name="xat:css.block">
        <xsl:param name="selectors" as="xs:string*"/>
        <xsl:param name="definitions" as="xs:string*"/>
        <xsl:variable name="sels" select="string-join($selectors, ', ')"/>
        <xsl:variable name="defs" select="string-join($definitions, ';')"/>
        <xsl:value-of select="concat($sels, ' {', $defs, '}')"/>
    </xsl:function>

    <xsl:function name="xat:css.comment">
        <xsl:param name="comment"/>
        <xsl:value-of select="concat('/*', $comment, '*/')"/>
    </xsl:function>



</xsl:stylesheet>
