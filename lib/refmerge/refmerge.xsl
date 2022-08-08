<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:import href="../utils/xsl-2.0/pathuri.xsl"/>


    <xsl:template match="*" mode="xat.refmerge.currUri">
        <xsl:value-of select="base-uri(.)"/>
    </xsl:template>

    <xsl:function name="xat:refmerge.currUri">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.refmerge.currUri"/>
    </xsl:function>

    <xsl:template match="*" mode="xat.refmerge.refUri">
        <xsl:value-of select="@href"/>
    </xsl:template>

    <xsl:function name="xat:refmerge.refUri">
        <xsl:param name="link"/>
        <xsl:apply-templates select="$link" mode="xat.refmerge.refUri"/>
    </xsl:function>

    <xsl:template match="node() | @*" mode="xat.refmerge.isLink" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[@href]" mode="xat.refmerge.isLink" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:refmerge.isLink" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.refmerge.isLink"/>
    </xsl:function>

    <xsl:function name="xat:refmerge.isNew" as="xs:boolean">
        <xsl:param name="uri"/>
        <xsl:param name="history"/>
        <xsl:sequence select="not(exists($history//@uri[. = $uri]))"/>
    </xsl:function>

    <xsl:template match="*[xat:refmerge.isLink(.)]" mode="xat.refmerge">
        <xsl:param name="history"/>

        <xsl:variable name="absRefUri">
            <xsl:value-of select="xat:uri.absoluteRef(base-uri(.), xat:refmerge.refUri(.))"/>
        </xsl:variable>

        <xsl:variable name="component" select="document($absRefUri)"/>
        <xsl:variable name="docBaseUri" select="base-uri($component)"/>

        <xsl:if test="xat:refmerge.isNew($docBaseUri, $history)">
            <xsl:apply-templates select="$component/*" mode="xat.refmerge">
                <xsl:with-param name="history" select="$history"/>
            </xsl:apply-templates>
        </xsl:if>

    </xsl:template>

    <xsl:template match="node() | @*" mode="xat.refmerge">
        <xsl:param name="history" select="()"/>
        
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="xat.refmerge">
                <xsl:with-param name="history">
                    <xsl:copy-of select="$history"/>
                    <file uri="{xat:refmerge.currUri(.)}"/>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:copy>

    </xsl:template>

</xsl:stylesheet>
