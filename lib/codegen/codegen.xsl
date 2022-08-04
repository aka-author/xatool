<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xat="http://itsurim.com/xatool" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xat xs" version="2.0">

    <xsl:function name="xat:codegen.parenthesis">
        <xsl:param name="str"/>
        <xsl:value-of select="concat('(', $str, ')')"/>
    </xsl:function>
    
    <xsl:function name="xat:codegen.brackets">
        <xsl:param name="str"/>
        <xsl:value-of select="concat('[', $str, ']')"/>
    </xsl:function>
    
    <xsl:function name="xat:codegen.braces">
        <xsl:param name="str"/>
        <xsl:value-of select="concat('{', $str, '}')"/>
    </xsl:function>
    
    <xsl:function name="xat:codegen.list">
        <xsl:param name="strSeq" as="xs:string*"/>
        <xsl:value-of select="string-join($strSeq, ', ')"/>
    </xsl:function>

    <xsl:function name="xat:codegen.escapeExplicit">
        <xsl:param name="rawCode"/>
        <xsl:param name="escapeRules"/>

        <xsl:variable name="escapePartialRegexps" as="xs:string*">
            <xsl:for-each select="$escapeRules//*[@regexp and @escaped]">
                <xsl:value-of select="xat:codegen.parenthesis(@regexp)"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="escapeRegexp" select="string-join($escapePartialRegexps, '|')"/>

        <xsl:analyze-string select="$rawCode" regex="{$escapeRegexp}">
            <xsl:matching-substring>
                <xsl:variable name="find" select="."/>
                <xsl:for-each select="$escapeRules//*[@regexp and @escaped]">
                    <xsl:if test="matches($find, @regexp)">
                        <xsl:value-of select="@escaped"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="." disable-output-escaping="yes"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>

    </xsl:function>

    <xsl:function name="xat:codegen.escapeRegular">
        <xsl:param name="rawCode"/>
        <xsl:param name="detectHaramRegexp"/>
        <xsl:param name="prefix"/>
        <xsl:param name="postfix"/>

        <xsl:analyze-string select="$rawCode" regex="{$detectHaramRegexp}">
            <xsl:matching-substring>
                <xsl:value-of select="concat($prefix, ., $postfix)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>

    </xsl:function>

    <xsl:function name="xat:codegen.quote">
        <xsl:param name="str"/>
        <xsl:value-of select="concat('&quot;', $str, '&quot;')"/>
    </xsl:function>

    <xsl:function name="xat:codegen.quoteApos">
        <xsl:param name="str"/>
        <xsl:value-of select='concat("&apos;", $str, "&apos;")'/>
    </xsl:function>

    <xsl:function name="xat:codegen.guoteFlexible">
        <xsl:param name="str"/>

        <xsl:variable name="q">
            <xsl:choose>
                <xsl:when test="contains($str, '&quot;')">
                    <xsl:text>&apos;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="concat($q, $str, $q)"/>

    </xsl:function>


</xsl:stylesheet>
