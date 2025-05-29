<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     winpath.xsl
    Usage:      Guts    
    Func:       Parsing and assembling Windows paths
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
        Converting a Windows path to an URI
    -->
    
    <xsl:template match="*[lower-case(@os) = 'windows']" mode="xat:path.2uri">

        <xsl:variable name="strIRI">
            <xsl:text>file:/</xsl:text>
            <xsl:value-of select="translate(@path, '\', '/')"/>
        </xsl:variable>

        <xsl:value-of select="iri-to-uri($strIRI)"/>

    </xsl:template>


    <!-- 
        Converting an URI to a Windows path
    -->
    
    <xsl:template match="*[lower-case(@os) = 'windows']" mode="xat:uri.2path">        

        <xsl:variable name="strRawPath">
            <xsl:value-of select="xat:uri.localFile(@uri)"/>
        </xsl:variable>

        <xsl:value-of select="xat:encoding.decodeURI(translate($strRawPath, '/', '\'))"/>

    </xsl:template>

</xsl:stylesheet>
