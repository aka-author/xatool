<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">
    
    <xsl:import href="../../../utils/xsl-2.0/pathuri.xsl"/>
    

    <!-- 
        Detecting element properties
    -->

    <!-- Getting an element ID -->

    <xsl:template match="*" mode="xat.dita.id">
        <xsl:value-of select="generate-id(.)"/>
    </xsl:template>

    <xsl:template match="*[@id]" mode="xat.dita.id">
        <xsl:value-of select="@id"/>
    </xsl:template>

    <xsl:template match="*[not(@id)]" mode="xat.dita.id">
        <xsl:value-of select="generate-id(.)"/>
    </xsl:template>

    <xsl:function name="xat:dita.id">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.id"/>
    </xsl:function>


    <!-- Detecting maps -->

    <xsl:template match="*" mode="xat.dita.isMap" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, 'map/map')]" mode="xat.dita.isMap" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isMap" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isMap"/>
    </xsl:function>


    <!-- Detecting topics -->

    <xsl:template match="*" mode="xat.dita.isTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, 'topic/topic')]" mode="xat.dita.isTopic" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTopic" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTopic"/>
    </xsl:function>
    
    
    <!-- Detecting terminal topics -->

    <xsl:template match="*" mode="xat.dita.isTerminalTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTopic(.)]" mode="xat.dita.isTerminalTopic" as="xs:boolean">
        <xsl:sequence select="not(exists(child::*[xat:dita.isTopic(.)]))"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTerminalTopic" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="xat.dita.isTerminalTopic"/>
    </xsl:function>


    <!-- Detecting folder topics -->

    <xsl:template match="*" mode="xat.dita.isFolderTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTopic(.)]" mode="xat.dita.isFolderTopic" as="xs:boolean">
        <xsl:sequence select="exists(child::*[xat:dita.isTopic(.)])"/>
    </xsl:template>

    <xsl:function name="xat:dita.isFolderTopic" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="xat.dita.isFolderTopic"/>
    </xsl:function>
    
    
    <!-- Deteching all structure nodes -->
    
    <xsl:template match="*" mode="xat.dita.isStructNode" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>
    
    <xsl:template match="*[xat:dita.isTopic(.)]" mode="xat.dita.isStructNode" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>
    
    <xsl:template match="*[xat:dita.isMap(.)]" mode="xat.dita.isStructNode" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>
    
    <xsl:function name="xat:dita.isStructNode" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isStructNode"/>
    </xsl:function>


    <!-- Detecting body elements -->

    <xsl:template match="*" mode="xat.dita.isBody" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, 'topic/body')]" mode="xat.dita.isBody" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isBody" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isBody"/>
    </xsl:function>


    <!-- Detecting elements containing direct text -->

    <xsl:template match="*" mode="xat.dita.hasDirectContent" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[*[xat:dita.isBody(.)]]" mode="xat.dita.hasDirectContent" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.hasDirectContent" as="xs:boolean">
        <xsl:param name="topic"/>
        <xsl:apply-templates select="$topic" mode="xat.dita.hasDirectContent"/>
    </xsl:function>


    <!-- Calculating the topic level -->

    <xsl:template match="*" mode="level" as="xs:integer">
        <xsl:sequence select="0"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTopic(.)]" mode="level" as="xs:integer">
        <xsl:value-of select="count(parent::*[xat:dita.isTopic(.)]) + 1"/>
    </xsl:template>

    <xsl:function name="xat:dita.level" as="xs:integer">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.level"/>
    </xsl:function>


    <!-- Element title -->

    <xsl:template match="*" mode="xat.dita.plainTextTitle">
        <xsl:value-of select="normalize-space(title)"/>
    </xsl:template>
    
    <xsl:template match="bookmap" mode="xat.dita.plainTextTitle">
        <xsl:value-of select="normalize-space(//mainbooktitle)"/>
    </xsl:template>

    <xsl:function name="xat:dita.plainTextTitle">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.plainTextTitle"/>
    </xsl:function>


    <!-- Document title -->

    <xsl:template match="*" mode="xat.dita.docTitle"/>

    <xsl:template match="map" mode="xat.dita.docTitle">
        <xsl:value-of select="title"/>
    </xsl:template>

    <xsl:template match="bookmap" mode="xat.dita.docTitle">
        <xsl:value-of select="//mainbooktitle"/>
    </xsl:template>

    <xsl:function name="xat:dita.docTitle">
        <xsl:param name="element"/>
        <xsl:apply-templates select="root($element)/*" mode="xat.dita.docTitle"/>
    </xsl:function>
    
    
    <!-- Detecting topic properties -->
    
    <xsl:template match="*" mode="xat.dita.fileUri"/>
    
    <xsl:template match="*[not(xat:dita.isStructNode(.))]" mode="xat.dita.fileUri">
        <xsl:apply-templates select="ancestor::*[xat:dita.isStructNode(.)]" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="*[xat:dita.isStructNode(.)]" mode="xat.dita.fileUri">
        <xsl:value-of select="xat:path.2uri(@xtrf, xat:path.os(@xtrf))"/>
    </xsl:template>
    
    <xsl:function name="xat:dita.fileUri">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.fileUri"/>
    </xsl:function>

</xsl:stylesheet>
