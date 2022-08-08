<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     uriquery.xsl
    Usage:      Guts    
    Func:       Analyzing and assembling URIs
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- 
        Modules 
    -->

    <!-- Parsing URIs -->
    <xsl:import href="uriparse.xsl"/>
    
    <!-- Serializing URI -->
    <xsl:import href="uriserialize.xsl"/>


    <!-- 
        Retrieving URI parts
    -->

    <!-- http -->
    <xsl:function name="xat:uri.protocol">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//protocol"/>
    </xsl:function>

    <!-- daRKlOrd -->
    <xsl:function name="xat:uri.login">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//login"/>
    </xsl:function>
    
    <!-- qwerty -->
    <xsl:function name="xat:uri.password">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//password"/>
    </xsl:function>

    <!-- www.example.com -->
    <xsl:function name="xat:uri.host">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//host"/>
    </xsl:function>
    
    <!-- 80 -->
    <xsl:function name="xat:uri.port">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//port"/>
    </xsl:function>

    <!-- www.example.com:80 -->
    <xsl:function name="xat:uri.hostPort">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:variable name="strHostPort">
            <xsl:value-of select="$xmlURI//host"/>
            <xsl:if test="$xmlURI//port">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="$xmlURI//port"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$strHostPort"/>
    </xsl:function>

    <!-- c: -->
    <xsl:function name="xat:uri.drive">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:variable name="strDrive">
            <xsl:if test="$xmlURI//drive">
                <xsl:value-of select="$xmlURI//drive"/>
                <xsl:text>:</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$strDrive"/>
    </xsl:function>

    

    <!-- c:/zoo/animals/wombat.html -->
    <xsl:function name="xat:uri.localFile">
        <xsl:param name="strURI"/>

        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>

        <xsl:variable name="strLocalFile">

            <xsl:if test="$xmlURI//drive">
                <xsl:value-of select="$xmlURI//drive"/>
                <xsl:text>:/</xsl:text>
            </xsl:if>

            <xsl:for-each select="$xmlURI//folder">
                <xsl:apply-templates select="." mode="xat.uri.serialize"/>
                <xsl:text>/</xsl:text>
            </xsl:for-each>

            <xsl:apply-templates select="$xmlURI//file" mode="xat.uri.serialize"/>

        </xsl:variable>

        <xsl:value-of select="$strLocalFile"/>

    </xsl:function>

    <!-- c:/zoo/animals -->
    <xsl:function name="xat:uri.parentFolder">
        <xsl:param name="strURI"/>
        
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        
        <xsl:variable name="xmlParentFolder">
            <uri>
                <xsl:copy-of select="$xmlURI/*[following-sibling::file]"/>
            </uri>
        </xsl:variable>
                
        <xsl:value-of select="xat:uri.serialize($xmlParentFolder)"/>
                
    </xsl:function>
    
    <!-- wombat.html -->
    <xsl:function name="xat:uri.filename">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:apply-templates select="$xmlURI//file" mode="xat.uri.serialize"/>        
    </xsl:function>
    
    <!-- wombat -->
    <xsl:function name="xat:uri.base">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//base"/>
    </xsl:function>
    
    <!-- html -->
    <xsl:function name="xat:uri.type">
        <xsl:param name="strURI"/>
        <xsl:variable name="xmlURI" select="xat:uriparse.uri($strURI)"/>
        <xsl:value-of select="$xmlURI//type"/>
    </xsl:function>


    <!-- 
        Validating URIs
    -->

    <xsl:function name="xat:uri.isRelative" as="xs:boolean">
        <xsl:param name="strURI"/>
        <!--
        <xsl:value-of select="matches($strURI, xat:urisyn.path())"/>
        -->
        <xsl:value-of select="not(contains($strURI, ':/'))"/>
    </xsl:function>

    <xsl:function name="xat:uri.isLocal" as="xs:boolean">
        <xsl:param name="strURI"/>
        <xsl:value-of select="matches($strURI, xat:urisyn.URI())"/>
    </xsl:function>

    <xsl:function name="xat:uri.isGlobal" as="xs:boolean">
        <xsl:param name="strURI"/>
        <xsl:value-of select="matches($strURI, xat:urisyn.globalURI())"/>
    </xsl:function>

    <xsl:function name="xat:uri.isURI" as="xs:boolean">
        <xsl:param name="strURI"/>
        <xsl:value-of select="xat:uri.isLocal($strURI) or xat:uri.isGlobal($strURI)"/>
    </xsl:function>

    <xsl:function name="xat:uri.isValid" as="xs:boolean">
        <xsl:param name="strURI"/>
        <xsl:value-of select="xat:uri.isRelative($strURI) or xat:uri.isURI($strURI)"/>
    </xsl:function>

</xsl:stylesheet>
