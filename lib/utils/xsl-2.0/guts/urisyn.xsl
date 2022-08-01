<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     urisyn.xsl
    Usage:      Guts    
    Func:       Providing regular expressions for parsing URIs
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cpm="http://cpmonster.com/xmlns/cpm"
    exclude-result-prefixes="cpm xs" version="2.0">

    <!-- 
        Modules
    -->

    <!-- Assembling regular expressions -->
    <xsl:import href="../regexp.xsl"/>


    <!-- 
        Assembling building blocks for URI regexps
    -->

    <!-- Characters and terms -->

    <xsl:function name="cpm:urisyn.commonChar">
        <xsl:text><![CDATA[(([A-Za-z\d\-\._~])|(%[A-F\d]{2}))]]></xsl:text>
    </xsl:function>

    <xsl:function name="cpm:urisyn.commonTerm">
        <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.commonChar(), '+')"/>
    </xsl:function>

    <xsl:function name="cpm:urisyn.hostChar">
        <xsl:text><![CDATA[[A-Za-z\d\-_~]]]></xsl:text>
    </xsl:function>

    <xsl:function name="cpm:urisyn.hostTerm">
        <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.hostChar(), '+')"/>
    </xsl:function>


    <!-- Protocol -->

    <!-- https -->
    <xsl:function name="cpm:urisyn.protocol">
        <xsl:value-of select="cpm:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- https: -->
    <xsl:function name="cpm:urisyn.fullProtocol">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.protocol()"/>
                <xsl:text>:</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Credentials -->

    <!-- daRkLoRd -->
    <xsl:function name="cpm:urisyn.login">
        <xsl:value-of select="cpm:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- qwerty -->
    <xsl:function name="cpm:urisyn.pwd">
        <xsl:value-of select="cpm:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- :querty -->
    <xsl:function name="cpm:urisyn.pwdGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="cpm:urisyn.pwd()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- daRkLoRd:querty -->
    <xsl:function name="cpm:urisyn.credentials">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.login()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.pwdGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- daRkLoRd:querty@ -->
    <xsl:function name="cpm:urisyn.credentialsGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.credentials()"/>
                <xsl:text>@</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Host -->

    <!-- .example -->
    <xsl:function name="cpm:urisyn.hostGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>\.</xsl:text>
                <xsl:value-of select="cpm:urisyn.hostTerm()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- www.example.com -->
    <xsl:function name="cpm:urisyn.host">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.hostTerm()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.hostGroup(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Port -->

    <!-- 80AF -->
    <xsl:function name="cpm:urisyn.port">
        <xsl:text><![CDATA[([\dA-F]+)]]></xsl:text>
    </xsl:function>

    <!-- :80AF -->
    <xsl:function name="cpm:urisyn.portGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="cpm:urisyn.port()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Host with a port number -->

    <!-- www.example.com:80AF -->
    <xsl:function name="cpm:urisyn.fullHost">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.host()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.portGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Address -->

    <!-- daRkLoRd:querty@www.example.com:80AF -->
    <xsl:function name="cpm:urisyn.address">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.credentialsGroup(), '?')"/>
                <xsl:value-of select="cpm:urisyn.fullHost()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- //daRkLoRd:querty@www.example.com:80AF -->
    <xsl:function name="cpm:urisyn.addressGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/\/</xsl:text>
                -->
                <xsl:text>//</xsl:text>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.address(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Anchor -->

    <!--  food -->
    <xsl:function name="cpm:urisyn.anchor">
        <xsl:value-of select="cpm:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- #food -->
    <xsl:function name="cpm:urisyn.anchorGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="cpm:urisyn.anchor()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Query parameters -->

    <!-- size -->
    <xsl:function name="cpm:urisyn.paramName">
        <xsl:value-of select="cpm:urisyn.hostTerm()"/>
    </xsl:function>

    <!-- 15 or whatever you want, say, krokodil%20begemot -->
    <xsl:function name="cpm:urisyn.paramValue">
        <xsl:value-of select="cpm:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- size=15 -->
    <xsl:function name="cpm:urisyn.param">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.paramName()"/>
                <xsl:text>=</xsl:text>
                <xsl:value-of select="cpm:urisyn.paramValue()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- &size=15 -->
    <xsl:function name="cpm:urisyn.paramGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>&amp;</xsl:text>
                <xsl:value-of select="cpm:urisyn.param()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- page=4&size=15 -->
    <xsl:function name="cpm:urisyn.params">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.param()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.paramGroup(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- ?page=4&size=15 -->
    <xsl:function name="cpm:urisyn.paramsGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:text>\?</xsl:text>
                <xsl:value-of select="cpm:urisyn.params()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Path as a part of an URI (not a local OS path!) -->

    <!-- c: -->
    <xsl:function name="cpm:urisyn.drive">
        <xsl:text><![CDATA[[A-Za-z]:]]></xsl:text>
    </xsl:function>

    <!-- /c: -->
    <xsl:function name="cpm:urisyn.driveGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="cpm:urisyn.drive()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- zoo -->
    <xsl:function name="cpm:urisyn.filename">
        <xsl:value-of select="cpm:urisyn.commonTerm()"/>
    </xsl:function>

    <!-- /zoo -->
    <xsl:function name="cpm:urisyn.filenameGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="cpm:urisyn.filename()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- zoo/animals/wombat.phtml -->
    <xsl:function name="cpm:urisyn.filePath">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.filename()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.filenameGroup(), '*')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- /zoo/animals/wombat.phtml -->
    <xsl:function name="cpm:urisyn.filePathGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="cpm:urisyn.path()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="cpm:urisyn.path">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.filePath()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.paramsGroup(), '?')"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.anchorGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!-- /zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="cpm:urisyn.pathGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="cpm:urisyn.path()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

    <!--
        Basically, query parameters don't make sense for a local 
        path. Nevertheless, we allow a local path to contain 
        query parameters. Perhaps, someone will need to use this 
        in custom applications. Who knows...
    -->

    <!-- c:/htdocs/zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="cpm:urisyn.fullPath">

        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.drive(), '?')"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.pathGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
        <!--
                <xsl:call-template name="cpm.regexp.choiseGroup">
            <xsl:with-param name="seqChoises">               
                <xsl:call-template name="cpm.regexp.sequenceGroup">
                    <xsl:with-param name="seqItems">
                        <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.drive(), '?')"/>
                        <xsl:value-of select="cpm:urisyn.pathGroup()"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="cpm:urisyn.drive()"/>
            </xsl:with-param>
        </xsl:call-template>
        -->
    </xsl:function>

    <!-- /c:/htdocs/zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="cpm:urisyn.fullPathGroup">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <!--
                <xsl:text>\/</xsl:text>
                -->
                <xsl:text>/</xsl:text>
                <xsl:value-of select="cpm:urisyn.fullPath()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Any URI (an address group is optional) -->

    <!-- file:/c:/htdocs/zoo/animals/wombat.phtml?page=4&size=15#food -->
    <xsl:function name="cpm:urisyn.URI">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.fullProtocol()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.addressGroup(), '?')"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.driveGroup(), '?')"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.pathGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>


    <!-- Global URI (an address group is mandatory; a drive is not permitted) -->

    <!-- http://daRkLoRd:querty@www.example.com:80/zoo/animals/wombat.py?page=5&size=15#food -->
    <xsl:function name="cpm:urisyn.globalURI">
        <xsl:call-template name="cpm.regexp.sequenceGroup">
            <xsl:with-param name="seqItems">
                <xsl:value-of select="cpm:urisyn.fullProtocol()"/>
                <xsl:value-of select="cpm:urisyn.addressGroup()"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.filePathGroup(), '?')"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.paramsGroup(), '?')"/>
                <xsl:value-of select="cpm:regexp.multiGroup(cpm:urisyn.anchorGroup(), '?')"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:function>

</xsl:stylesheet>
