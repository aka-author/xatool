<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">


    <!-- 
        Detecting block elements 
    -->

    <xsl:template match="node()" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/codeblock ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/div ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/equation-block ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/equation-figure ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/hazardstatement ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lines ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/lq ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/msgblock ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/screen ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/section ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/simpletable ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/table ')]" mode="xat.dita.isBlock"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/linkpool ')]" mode="xat.dita.isBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isBlock" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.dita.isBlock"/>
    </xsl:function>


    <!-- 
        Detecting table components
    -->

    <!-- Generic -->

    <xsl:template match="*" mode="xat.dita.isTableComponent" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" mode="xat:dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/thead ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tfoot ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/row ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/stentry ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sthead ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/strow ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/stentry ')]" mode="xat.dita.isTableComponent"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTableComponent" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTableComponent"/>
    </xsl:function>

    <!-- Entry -->

    <xsl:template match="*" mode="xat.dita.isTableEntry" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="xat.dita.isTableEntry"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/stentry ')]" mode="xat.dita.isTableEntry"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTableEntry" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTableEntry"/>
    </xsl:function>

    <!-- Row -->

    <xsl:template match="*" mode="xat.dita.isTableRow" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/row ')]" mode="xat.dita.isTableRow"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/strow ')]" mode="xat.dita.isTableRow"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTableRow" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTableRow"/>
    </xsl:function>

    <!-- Table -->

    <xsl:template match="*" mode="xat.dita.isTable" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/tgroup ')]" mode="xat.dita.isTable"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/simpletable ')]" mode="xat.dita.isTable"
        as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTable" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTable"/>
    </xsl:function>


    <!-- 
        Detecting inline nodes
    -->

    <xsl:template match="comment()" mode="xat.dita.isInline" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="text()" mode="xat.dita.isInline" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template match="*" mode="xat.dita.isInline" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:template
        match="*[xat:dita.isMap(.) or xat:dita.isTopic(.) or xat:dita.isTopicComponent(.) or xat:dita.isBlock(.) or xat:dita.isTableComponent(.)]"
        mode="xat.dita.isInline" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isInline" as="xs:boolean">
        <xsl:param name="node"/>
        <xsl:apply-templates select="$node" mode="xat.dita.isInline"/>
    </xsl:function>


    <!-- 
        Detecting topic titles
    -->

    <xsl:template match="*" mode="xat.dita.isTopicTitle" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTopic(.)]/*[contains(@class, ' topic/title ')]"
        mode="xat.dita.isTopicTitle" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTopicTitle" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTopicTitle"/>
    </xsl:function>


    <!-- 
        Detecting topic body elements 
    -->

    <xsl:template match="*" mode="xat.dita.isBody" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/body ')]" mode="xat.dita.isBody" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isBody" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isBody"/>
    </xsl:function>


    <!-- 
        Detecting related links blocks
    -->

    <xsl:template match="*" mode="xat.dita.isRelatedLinksBlock" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/related-links ')]"
        mode="xat.dita.isRelatedLinksBlock" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isRelatedLinksBlock" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isRelatedLinksBlock"/>
    </xsl:function>


    <!-- 
        Topic components
    -->

    <xsl:template match="*" mode="xat.dita.isTopicComponent" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template
        match="*[xat:dita.isTopicTitle(.) or xat:dita.isBody(.) or xat:dita.isRelatedLinksBlock(.)]"
        mode="xat.dita.isTopicComponent" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTopicComponent" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTopicComponent"/>
    </xsl:function>


    <!-- 
        Detecting topics 
    -->

    <xsl:template match="*" mode="xat.dita.isTopic" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="xat.dita.isTopic"
        as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isTopic" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isTopic"/>
    </xsl:function>


    <!-- 
        Detecting documents 
    -->

    <xsl:template match="*" mode="xat.dita.isMap" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/map ')]" mode="xat.dita.isMap" as="xs:boolean">
        <xsl:sequence select="true()"/>
    </xsl:template>

    <xsl:function name="xat:dita.isMap" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="xat.dita.isMap"/>
    </xsl:function>


    <!-- 
        Detectig an element's superclass
    -->

    <xsl:template match="*" mode="xat.dita.superclass">
        <xsl:value-of select="'generic'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isInline(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'inline'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isBlock(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'block'"/>
    </xsl:template>

    <xsl:template
        match="*[xat:dita.isTableComponent(.) and not(xat:dita.isTableEntry(.) or xat:dita.isTableRow(.))]"
        mode="xat.dita.superclass">
        <xsl:value-of select="'table__component'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTableEntry(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'table__component table_entry'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTableRow(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'table__component table_row'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTable(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'table'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTopicTitle(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'topic__component'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isBody(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'topic__component'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isRelatedLinksBlock(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'topic__component'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isTopic(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'struct_node'"/>
    </xsl:template>

    <xsl:template match="*[xat:dita.isMap(.)]" mode="xat.dita.superclass">
        <xsl:value-of select="'struct_node'"/>
    </xsl:template>

    <xsl:function name="xat:dita.superclass">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="xat.dita.superclass"/>

    </xsl:function>

</xsl:stylesheet>
