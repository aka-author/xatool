<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     regexp.xsl
    Usage:      Library  
    Func:       Building regular expressions
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    exclude-result-prefixes="xat xs" version="2.0">


    <!-- 
        Primitives
    -->

    <!-- Space characters -->
    <xsl:function name="xat:regexp.anySpace">
        <xsl:text><![CDATA[[\s\t\n]]]></xsl:text>
    </xsl:function>


    <!-- 
        Assembling regexps
    -->

    <!-- Putting this into brackets -->
    <xsl:function name="xat:regexp.group">
        <xsl:param name="strItem"/>
        <xsl:value-of select="concat('(', $strItem, ')')"/>
    </xsl:function>

    <!-- Putting this into optional leading and trailin spaces -->
    <xsl:function name="xat:regexp.pad">
        <xsl:param name="strItem"/>
        <xsl:call-template name="xat:regexp.sequence">
            <xsl:with-param name="seqItems" as="xs:string*">
                <xsl:value-of select="xat:regexp.multiGroup(xat:regexp.anySpace(), '*')"/>
                <xsl:value-of select="$strItem"/>
                <xsl:value-of select="xat:regexp.multiGroup(xat:regexp.anySpace(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- Appending mandatory spaces after an item -->
    <xsl:function name="xat:regexp.padRM">
        <xsl:param name="strItem"/>
        <xsl:call-template name="xat:regexp.sequenceGroup">
            <xsl:with-param name="seqItems" as="xs:string*">
                <xsl:value-of select="$strItem"/>
                <xsl:text><![CDATA[[\s\t\n]+]]></xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- Putting this into brackets -->
    <xsl:function name="xat:regexp.brackets">
        <xsl:param name="strItem"/>
        <xsl:value-of select="concat(xat:regexp.pad('\('), $strItem, xat:regexp.pad('\)'))"/>
    </xsl:function>

    <!-- Putting this into curly brackets -->
    <xsl:function name="xat:regexp.curlyBrackets">
        <xsl:param name="strItem"/>
        <xsl:value-of select="concat(xat:regexp.pad('\{'), $strItem, xat:regexp.pad('\}'))"/>
    </xsl:function>

    <!-- Assembling group with a multiplier -->
    <xsl:function name="xat:regexp.multiGroup">
        <xsl:param name="strItem"/>
        <xsl:param name="strMultiplier"/>
        <xsl:value-of select="xat:regexp.group(concat(xat:regexp.group($strItem), $strMultiplier))"
        />
    </xsl:function>

    <!-- Turning a sequence to a sequence of groups -->
    <xsl:function name="xat:regexp.groups" as="xs:string*">
        <xsl:param name="seqItems" as="xs:string*"/>
        <xsl:for-each select="$seqItems">
            <xsl:value-of select="xat:regexp.group(.)"/>
        </xsl:for-each>
    </xsl:function>

    <!-- Assembling a binary operation over multiple polymorphic operands -->
    <xsl:template name="xat:regexp.multiple">
        <xsl:param name="seqOperands" as="xs:string*"/>
        <xsl:param name="strOperator"/>
        <xsl:variable name="seqOperandGroups" as="xs:string*">
            <xsl:copy-of select="xat:regexp.groups($seqOperands)"/>
        </xsl:variable>
        <xsl:variable name="strPaddedOperator">
            <xsl:value-of select="xat:regexp.group(xat:regexp.pad($strOperator))"/>
        </xsl:variable>
        <xsl:value-of select="string-join($seqOperandGroups, $strPaddedOperator)"/>
    </xsl:template>

    <!-- Assembling a binary operation over two polymorphic operands -->
    <xsl:function name="xat:regexp.binary">
        <xsl:param name="strOperand1"/>
        <xsl:param name="strOperand2"/>
        <xsl:param name="strOperator"/>
        <xsl:call-template name="xat:regexp.multiple">
            <xsl:with-param name="seqOperands" as="xs:string*">
                <xsl:value-of select="$strOperand1"/>
                <xsl:value-of select="$strOperand2"/>
            </xsl:with-param>
            <xsl:with-param name="strOperator" select="$strOperator"/>
        </xsl:call-template>
    </xsl:function>

    <!-- Assembling a binary operation over two uniform operands -->
    <xsl:function name="xat:regexp.simpleBinary">
        <xsl:param name="strOperand"/>
        <xsl:param name="strOperator"/>
        <xsl:call-template name="xat:regexp.multiple">
            <xsl:with-param name="seqOperands" as="xs:string*">
                <xsl:value-of select="$strOperand"/>
                <xsl:value-of select="$strOperand"/>
            </xsl:with-param>
            <xsl:with-param name="strOperator" select="$strOperator"/>
        </xsl:call-template>
    </xsl:function>

    <!-- Assembling a binary operation over multiple uniform operands -->
    <xsl:function name="xat:regexp.multiple">
        <xsl:param name="strOperand"/>
        <xsl:param name="strOperator"/>
        <xsl:variable name="strPaddedOperator">
            <xsl:value-of select="xat:regexp.group(xat:regexp.pad($strOperator))"/>
        </xsl:variable>
        <xsl:variable name="strOperandGroup">
            <xsl:value-of select="xat:regexp.group($strOperand)"/>
        </xsl:variable>
        <xsl:variable name="strOptionalGroup">
            <xsl:value-of select="xat:regexp.group(concat($strPaddedOperator, $strOperandGroup))"/>
        </xsl:variable>
        <xsl:variable name="tmp">
            <xsl:value-of select="xat:regexp.simpleBinary($strOperandGroup, $strOperator)"/>
            <xsl:value-of select="xat:regexp.multiGroup($strOptionalGroup, '*')"/>
        </xsl:variable>
        <xsl:value-of select="$tmp"/>
    </xsl:function>

    <!-- Assembling a sequence regexp -->
    <xsl:template name="xat:regexp.sequence">
        <xsl:param name="seqItems" as="xs:string*"/>
        <xsl:variable name="tmp">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="string-join($seqItems, ')(')"/>
            <xsl:text>)</xsl:text>
        </xsl:variable>
        <xsl:value-of select="$tmp"/>
    </xsl:template>

    <!-- Assembling a sequence group regexp -->
    <xsl:template name="xat:regexp.sequenceGroup">
        <xsl:param name="seqItems" as="xs:string*"/>
        <xsl:variable name="tmp">
            <xsl:call-template name="xat:regexp.sequence">
                <xsl:with-param name="seqItems" as="xs:string*">
                    <xsl:copy-of select="$seqItems"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="xat:regexp.group($tmp)"/>
    </xsl:template>

    <!-- Assembling a choise regexp -->
    <xsl:template name="xat:regexp.choise">
        <xsl:param name="seqChoises" as="xs:string*"/>
        <xsl:variable name="tmp">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="string-join($seqChoises, ')|(')"/>
            <xsl:text>)</xsl:text>
        </xsl:variable>
        <xsl:value-of select="$tmp"/>
    </xsl:template>

    <!-- Assembling a choise group regexp -->
    <xsl:template name="xat:regexp.choiseGroup">
        <xsl:param name="seqChoises" as="xs:string*"/>
        <xsl:variable name="tmp">
            <xsl:call-template name="xat:regexp.choise">
                <xsl:with-param name="seqChoises" as="xs:string*">
                    <xsl:copy-of select="$seqChoises"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="xat:regexp.group($tmp)"/>
    </xsl:template>

    <!-- Assembling a list gerexp -->
    <xsl:function name="xat:regexp.list">

        <xsl:param name="strItem"/>

        <xsl:param name="strSeparator"/>

        <xsl:variable name="strOptionalItem">
            <xsl:call-template name="xat:regexp.sequence">
                <xsl:with-param name="seqItems" as="xs:string*">
                    <xsl:value-of select="$strSeparator"/>
                    <xsl:value-of select="$strItem"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="strTail" select="xat:regexp.multiGroup($strOptionalItem, '*')"/>

        <xsl:call-template name="xat:regexp.sequence">
            <xsl:with-param name="seqItems" as="xs:string*">
                <xsl:value-of select="$strItem"/>
                <xsl:value-of select="$strTail"/>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:function>

    <!-- Assembling a list gerexp; an optional trailing separator is permitted -->
    <xsl:function name="xat:regexp.trailedList">

        <xsl:param name="strItem"/>

        <xsl:param name="strSeparator"/>

        <xsl:call-template name="xat:regexp.sequence">
            <xsl:with-param name="seqItems" as="xs:string*">
                <xsl:value-of select="xat:regexp.list($strItem, $strSeparator)"/>
                <xsl:value-of select="xat:regexp.multiGroup($strSeparator, '?')"/>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:function>

    <!-- Placing a string to the beginning of a string ^... -->
    <xsl:function name="xat:regexp.start">
        <xsl:param name="strItem"/>
        <xsl:value-of select="concat('^', $strItem)"/>
    </xsl:function>

    <!-- Placing a string to the end of a string ...$ -->
    <xsl:function name="xat:regexp.end">
        <xsl:param name="strItem"/>
        <xsl:value-of select="concat($strItem, '$')"/>
    </xsl:function>

    <!-- Placing a string between start and end of a string ^...$ -->
    <xsl:function name="xat:regexp.wholeString">
        <xsl:param name="strItem"/>
        <xsl:value-of select="concat('^', $strItem, '$')"/>
    </xsl:function>
    
    <xsl:template name="xat:regexp.wholeString">
        <xsl:param name="strItem"/>
        <xsl:value-of select="xat:regexp.wholeString($strItem)"/>
    </xsl:template>

</xsl:stylesheet>
