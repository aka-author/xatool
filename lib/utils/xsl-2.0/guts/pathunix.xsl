<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     unixpath.xsl
    Usage:      Guts    
    Func:       Parsing and assembling Unix paths
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Working with URIs -->
    <xsl:import href="uri.xsl"/>
    

    <!--  
        Converting a Unix path to an URI
    -->
    
    <xsl:template match="*[lower-case(@os) = ('mac', 'linux', 'unix')]" mode="xat:path.2uri">

        <xsl:variable name="strPathGroup">
            <xsl:choose>
                <xsl:when test="starts-with(@path, '/')">
                    <xsl:value-of select="@path"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('/', @path)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="iri-to-uri(concat('file:', $strPathGroup))"/>

    </xsl:template>


    <!--
        Converting an URI to a Unix path
    -->
    
    <xsl:template match="*[lower-case(@os) = ('mac', 'linux', 'unix')]" mode="xat:uri.2path">
        <xsl:value-of select="xat:encoding.decodeURI(concat('/', xat:uri.localFile(@uri)))"/>
    </xsl:template>

</xsl:stylesheet>
