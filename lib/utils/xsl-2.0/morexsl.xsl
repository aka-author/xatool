<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     morexsl.xsl    
    Usage:      Library
    Func:       Performing frequently used tests and output content 
                generation activities 
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    xmlns:uuid="java.util.UUID" exclude-result-prefixes="xat uuid xs" version="2.0">

    <!-- 
        Unique identifiers
    -->

    <!-- Detecting the @id of an element -->
    
    <xsl:template match="*" mode="xat:morexsl.getgenId">
        <xsl:value-of select="generate-id()"/>
    </xsl:template>
    
    <xsl:template match="*[@id]" mode="xat:morexsl.getgenId">
        <xsl:value-of select="@id"/>
    </xsl:template>
    
    <xsl:function name="xat:morexsl.id">
        <xsl:param name="elmItem"/>
        <xsl:apply-templates select="$elmItem" mode="xat:morexsl.getgenId"/>
    </xsl:function>
    
    <!-- Checking an element id-->
    <xsl:function name="xat:morexsl.checkId" as="xs:boolean">
        <xsl:param name="elmItem"/>
        <xsl:param name="idToBeChecked"/>
        <xsl:value-of select="xat:morexsl.id($elmItem) = $idToBeChecked"/>
    </xsl:function>

    <!-- Getting a new UUID -->
    <xsl:function name="xat:morexsl.UUID">
        <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:function>

    <!-- Creating an @id attribute if does not exist yet -->
    <xsl:template match="*" mode="xat:morexsl.id">
        <xsl:if test="not(@id)">
            <xsl:attribute name="id" select="generate-id()"/>
        </xsl:if>
    </xsl:template>

    <!-- Creating an @id attribute using UUID -->
    <xsl:template match="*" mode="xat:morexsl.UUID">
        <xsl:if test="not(@id)">
            <xsl:attribute name="id" select="xat:morexsl.UUID()"/>
        </xsl:if>
    </xsl:template>


    <!-- 
        Detecting elements
    -->

    <!-- Is a node an element? -->
    <xsl:function name="xat:morexsl.isElement" as="xs:boolean">
        <xsl:param name="xmlNode"/>
        <xsl:value-of select="name($xmlNode) = ''"/>
    </xsl:function>


</xsl:stylesheet>
