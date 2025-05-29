<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:import href="../../../common/xsl-2.0/common.xsl"/>

    <xsl:template name="xat:html.scriptJs">
        <xsl:param name="src" select="''"/>
        <xsl:param name="content" select="''"/>
        <xsl:param name="defer" select="''"/>

        <xsl:element name="script">

            <xsl:copy-of select="xat:usefulAttr('src', $src)"/>

            <xsl:if test="$defer = 'on'">
                <xsl:attribute name="defer">defer</xsl:attribute>
            </xsl:if>

            <xsl:if test="not($content = '')">
                <xsl:value-of select="$content" disable-output-escaping="yes"/>
            </xsl:if>

        </xsl:element>

    </xsl:template>


</xsl:stylesheet>
