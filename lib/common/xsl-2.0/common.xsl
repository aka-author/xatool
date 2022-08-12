<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:template match="*" mode="xat.id">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="generate-id()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:function name="xat:id">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.id"/>
    </xsl:function>

    <xsl:function name="xat:usefulAttr">
        <xsl:param name="attrName"/>
        <xsl:param name="attrValue"/>

        <xsl:if test="$attrValue != '' and not(empty($attrValue))">
            <xsl:attribute name="{$attrName}" select="$attrValue"/>
        </xsl:if>

    </xsl:function>

</xsl:stylesheet>
