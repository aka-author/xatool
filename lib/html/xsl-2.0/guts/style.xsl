<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:template name="xat:html.linkCss">
        <xsl:param name="href"/>

        <xsl:element name="link">
            <xsl:attribute name="rel" select="'stylesheet'"/>
            <xsl:attribute name="href" select="$href"/>
        </xsl:element>

    </xsl:template>


    <xsl:function name="xat:css.styleItem">

        <xsl:param name="propName"/>
        <xsl:param name="propValue"/>
        
        <xsl:variable name="normPropVal" select="normalize-space($propValue)"/>

        <xsl:if test="$normPropVal != ''">
            <xsl:value-of select="concat($propName, ': ', $normPropVal)"/>
        </xsl:if>

    </xsl:function>


    <xsl:function name="xat:css.style">

        <xsl:param name="styleItems" as="xs:string*"/>
        
        <xsl:variable name="usefulItems" as="xs:string*">
            <xsl:for-each select="$styleItems">
                <xsl:if test="normalize-space(.) != ''">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:if test="normalize-space(string-join($usefulItems, '')) != ''">
            <xsl:value-of select="normalize-space(string-join($usefulItems, '; '))"/>    
        </xsl:if>

    </xsl:function>

</xsl:stylesheet>
