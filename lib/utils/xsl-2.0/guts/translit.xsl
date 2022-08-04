<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     translit.xsl    
    Usage:      Guts
    Func:       Transliterating strings
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Working with symbol encoding -->
    <xsl:import href="encoding.xsl"/>


    <!-- 
        Loading transliteration tables
    -->

    <!-- No transliteration table is provided by default -->
    <xsl:template match="*" mode="xat.translit.load"/>

    <!-- Cyrillic to ASCII -->
    <xsl:template match="*[@source = 'Cyrillic' and @target = 'ASCII']" mode="xat.translit.load">
        <xsl:copy-of select="document('../data/translit/Cyrillic.xml')"/>
    </xsl:template>

    <!-- Hebrew to ASCII -->
    <xsl:template match="*[@source = 'Hebrew' and @target = 'ASCII']" mode="xat.translit.load">
        <xsl:copy-of select="document('../data/translit/Hebrew.xml')"/>
    </xsl:template>

    <!-- Wrapper function -->
    <xsl:function name="xat:translit.load">
        <xsl:param name="strSource"/>
        <xsl:param name="strTarget"/>
        <xsl:variable name="xmlRequest">
            <request source="{$strSource}" target="{$strTarget}"/>
        </xsl:variable>
        <xsl:variable name="xmlTable">
            <xsl:apply-templates select="$xmlRequest" mode="xat.translit.load"/>
        </xsl:variable>
        <xsl:copy-of select="$xmlTable//alphabet[@source = $strSource and @target = $strTarget]"/>
    </xsl:function>


    <!-- 
        Transliterating strings
    -->

    <!-- A target is explicit -->
    <xsl:function name="xat:translit.mono">
        <xsl:param name="strItem"/>
        <xsl:param name="strSource"/>
        <xsl:param name="strTarget"/>

        <xsl:variable name="xmlAlpha" select="xat:translit.load($strSource, $strTarget)"/>
        <xsl:variable name="strSource" select="$xmlAlpha//translate/@source"/>
        <xsl:variable name="strTarget" select="$xmlAlpha//translate/@target"/>

        <xsl:variable name="strTransliterated">
            <xsl:for-each select="xat:encoding.sequence($strItem)">

                <xsl:variable name="chrCurr" select="."/>

                <xsl:choose>

                    <xsl:when test="xat:encoding.isASCII(.)">
                        <xsl:value-of select="$chrCurr"/>
                    </xsl:when>

                    <xsl:otherwise>

                        <xsl:variable name="chrRawTarget">
                            <xsl:if test="$strSource != ''">
                                <xsl:value-of select="translate($chrCurr, $strSource, $strTarget)"/>
                            </xsl:if>
                        </xsl:variable>

                        <xsl:choose>
                            <xsl:when test="$chrRawTarget != $chrCurr">
                                <xsl:value-of select="$chrRawTarget"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$xmlAlpha//char[@source = $chrCurr]/@target"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:otherwise>

                </xsl:choose>

            </xsl:for-each>
        </xsl:variable>

        <xsl:value-of select="$strTransliterated"/>

    </xsl:function>

    <!-- A target is auto detected -->
    <xsl:function name="xat:translit.monoAuto">
        <xsl:param name="strItem"/>
        <xsl:param name="strTarget"/>
        <xsl:variable name="strSource" select="xat:encoding.strRange($strItem)"/>
        <xsl:value-of select="xat:translit.mono($strItem, $strSource, $strTarget)"/>
    </xsl:function>

</xsl:stylesheet>
