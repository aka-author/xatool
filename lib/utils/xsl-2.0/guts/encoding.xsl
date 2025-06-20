<?xml version="1.0" encoding="UTF-8"?>
<!-- * * ** *** ***** ******** ************* ********************* -->
<!--    
    Product:    CopyPaste Monster    
    Area:       Libraries    
    Part:       Utils
    Module:     encoding.xsl    
    Usage:      Guts
    Func:       Working with symbol encoding
-->    
<!-- * * ** *** ***** ******** ************* ********************* -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xat="http://itsurim.com/xatool"
    xmlns:java-urldecode="java:java.net.URLDecoder" exclude-result-prefixes="xat java-urldecode xs"
    version="2.0">

    <!-- 
         Unicode
    -->
    
    <!-- Replacing codes like %20 with corresponding Unicode characters -->
    
    <!-- Convert UTF-8 bytes to Unicode codepoint -->
    <xsl:function name="xat:utf8-bytes-to-codepoint" as="xs:integer">
        <xsl:param name="bytes" as="xs:integer*"/>
        <xsl:param name="numBytes" as="xs:integer"/>
        
        <xsl:choose>
            <!-- 2-byte UTF-8 -->
            <xsl:when test="$numBytes eq 2">
                <xsl:variable name="byte1" select="$bytes[1]"/>
                <xsl:variable name="byte2" select="$bytes[2]"/>
                <!-- Validate continuation byte -->
                <xsl:choose>
                    <xsl:when test="$byte2 ge 128 and $byte2 lt 192">
                        <xsl:sequence select="(($byte1 - 192) * 64) + ($byte2 - 128)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- 3-byte UTF-8 -->
            <xsl:when test="$numBytes eq 3">
                <xsl:variable name="byte1" select="$bytes[1]"/>
                <xsl:variable name="byte2" select="$bytes[2]"/>
                <xsl:variable name="byte3" select="$bytes[3]"/>
                <!-- Validate continuation bytes -->
                <xsl:choose>
                    <xsl:when test="$byte2 ge 128 and $byte2 lt 192 and $byte3 ge 128 and $byte3 lt 192">
                        <xsl:sequence select="(($byte1 - 224) * 4096) + (($byte2 - 128) * 64) + ($byte3 - 128)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- 4-byte UTF-8 -->
            <xsl:when test="$numBytes eq 4">
                <xsl:variable name="byte1" select="$bytes[1]"/>
                <xsl:variable name="byte2" select="$bytes[2]"/>
                <xsl:variable name="byte3" select="$bytes[3]"/>
                <xsl:variable name="byte4" select="$bytes[4]"/>
                <!-- Validate continuation bytes -->
                <xsl:choose>
                    <xsl:when test="$byte2 ge 128 and $byte2 lt 192 and $byte3 ge 128 and $byte3 lt 192 and $byte4 ge 128 and $byte4 lt 192">
                        <xsl:sequence select="(($byte1 - 240) * 262144) + (($byte2 - 128) * 4096) + (($byte3 - 128) * 64) + ($byte4 - 128)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Helper function to get numeric value of hex digit -->
    <xsl:function name="xat:hex-digit-value" as="xs:integer">
        <xsl:param name="digit" as="xs:string"/>
        
        <xsl:choose>
            <xsl:when test="$digit eq '0'">0</xsl:when>
            <xsl:when test="$digit eq '1'">1</xsl:when>
            <xsl:when test="$digit eq '2'">2</xsl:when>
            <xsl:when test="$digit eq '3'">3</xsl:when>
            <xsl:when test="$digit eq '4'">4</xsl:when>
            <xsl:when test="$digit eq '5'">5</xsl:when>
            <xsl:when test="$digit eq '6'">6</xsl:when>
            <xsl:when test="$digit eq '7'">7</xsl:when>
            <xsl:when test="$digit eq '8'">8</xsl:when>
            <xsl:when test="$digit eq '9'">9</xsl:when>
            <xsl:when test="$digit eq 'A'">10</xsl:when>
            <xsl:when test="$digit eq 'B'">11</xsl:when>
            <xsl:when test="$digit eq 'C'">12</xsl:when>
            <xsl:when test="$digit eq 'D'">13</xsl:when>
            <xsl:when test="$digit eq 'E'">14</xsl:when>
            <xsl:when test="$digit eq 'F'">15</xsl:when>
            <xsl:otherwise>0</xsl:otherwise> <!-- fallback for invalid hex -->
        </xsl:choose>
    </xsl:function>
    
    <!-- Helper function to convert hex string to decimal -->
    <xsl:function name="xat:hex-to-decimal" as="xs:integer">
        <xsl:param name="hex" as="xs:string"/>
        
        <xsl:variable name="upperHex" select="upper-case($hex)"/>
        <xsl:variable name="digit1" select="xat:hex-digit-value(substring($upperHex, 1, 1))"/>
        <xsl:variable name="digit2" select="xat:hex-digit-value(substring($upperHex, 2, 1))"/>
        
        <xsl:sequence select="$digit1 * 16 + $digit2"/>
    </xsl:function>
    
    <!-- Extract UTF-8 bytes from percent-encoded string -->
    <xsl:function name="xat:extract-utf8-bytes" as="xs:integer*">
        <xsl:param name="input" as="xs:string"/>
        <xsl:param name="numBytes" as="xs:integer"/>
        
        <xsl:choose>
            <xsl:when test="$numBytes eq 0">
                <xsl:sequence select="()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="hex" select="substring($input, 2, 2)"/>
                <xsl:variable name="byte" select="xat:hex-to-decimal($hex)"/>
                <xsl:variable name="rest" select="xat:extract-utf8-bytes(substring($input, 4), $numBytes - 1)"/>
                <xsl:sequence select="($byte, $rest)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Function to decode multi-byte UTF-8 sequence -->
    <xsl:function name="xat:decode-utf8-multibyte" as="xs:string*">
        <xsl:param name="input" as="xs:string"/>
        <xsl:param name="numBytes" as="xs:integer"/>
        
        <!-- Check if we have enough bytes -->
        <xsl:variable name="requiredLength" select="$numBytes * 3"/>
        <xsl:choose>
            <xsl:when test="string-length($input) lt $requiredLength">
                <xsl:sequence select="('', $input)"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:variable name="bytes" select="xat:extract-utf8-bytes($input, $numBytes)"/>
                <xsl:variable name="codepoint" select="xat:utf8-bytes-to-codepoint($bytes, $numBytes)"/>
                
                <xsl:choose>
                    <xsl:when test="$codepoint gt 0">
                        <xsl:sequence select="(codepoints-to-string($codepoint), substring($input, $requiredLength + 1))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="('', $input)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Function to decode UTF-8 byte sequence starting with % -->
    <xsl:function name="xat:decode-utf8-sequence" as="xs:string*">
        <xsl:param name="input" as="xs:string"/>
        
        <!-- Get first byte -->
        <xsl:variable name="firstHex" select="substring($input, 2, 2)"/>
        
        <xsl:choose>
            <!-- Invalid hex -->
            <xsl:when test="not(matches($firstHex, '^[0-9A-Fa-f]{2}$'))">
                <xsl:sequence select="('', $input)"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:variable name="firstByte" select="xat:hex-to-decimal($firstHex)"/>
                
                <xsl:choose>
                    <!-- ASCII (0xxxxxxx) - single byte -->
                    <xsl:when test="$firstByte lt 128">
                        <xsl:sequence select="(codepoints-to-string($firstByte), substring($input, 4))"/>
                    </xsl:when>
                    
                    <!-- 2-byte UTF-8 (110xxxxx 10xxxxxx) -->
                    <xsl:when test="$firstByte ge 192 and $firstByte lt 224">
                        <xsl:sequence select="xat:decode-utf8-multibyte($input, 2)"/>
                    </xsl:when>
                    
                    <!-- 3-byte UTF-8 (1110xxxx 10xxxxxx 10xxxxxx) -->
                    <xsl:when test="$firstByte ge 224 and $firstByte lt 240">
                        <xsl:sequence select="xat:decode-utf8-multibyte($input, 3)"/>
                    </xsl:when>
                    
                    <!-- 4-byte UTF-8 (11110xxx 10xxxxxx 10xxxxxx 10xxxxxx) -->
                    <xsl:when test="$firstByte ge 240 and $firstByte lt 248">
                        <xsl:sequence select="xat:decode-utf8-multibyte($input, 4)"/>
                    </xsl:when>
                    
                    <!-- Invalid UTF-8 start byte -->
                    <xsl:otherwise>
                        <xsl:sequence select="('', $input)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Helper function for recursive processing -->
    <xsl:function name="xat:uridecode-helper" as="xs:string">
        <xsl:param name="remaining" as="xs:string"/>
        <xsl:param name="result" as="xs:string"/>
        
        <xsl:choose>
            <!-- Base case: no more characters to process -->
            <xsl:when test="string-length($remaining) = 0">
                <xsl:sequence select="$result"/>
            </xsl:when>
            
            <!-- Found a % character - decode UTF-8 sequence -->
            <xsl:when test="starts-with($remaining, '%')">
                <xsl:variable name="utf8Result" select="xat:decode-utf8-sequence($remaining)"/>
                <xsl:variable name="decodedChar" select="$utf8Result[1]"/>
                <xsl:variable name="remainingAfterSequence" select="$utf8Result[2]"/>
                
                <xsl:choose>
                    <xsl:when test="string-length($decodedChar) gt 0">
                        <xsl:sequence select="xat:uridecode-helper($remainingAfterSequence, concat($result, $decodedChar))"/>
                    </xsl:when>
                    <!-- Invalid sequence - keep the % as literal -->
                    <xsl:otherwise>
                        <xsl:sequence select="xat:uridecode-helper(substring($remaining, 2), concat($result, '%'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            
            <!-- Regular character - add to result and continue -->
            <xsl:otherwise>
                <xsl:variable name="firstChar" select="substring($remaining, 1, 1)"/>
                <xsl:variable name="rest" select="substring($remaining, 2)"/>
                <xsl:sequence select="xat:uridecode-helper($rest, concat($result, $firstChar))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Pure function to decode URI-encoded strings to UTF-8 -->
    <xsl:function name="xat:uridecode" as="xs:string">
        
        <xsl:param name="encodedUri" as="xs:string"/>
        
        <xsl:choose>
            <!-- If no % characters, return as-is -->
            <xsl:when test="not(contains($encodedUri, '%'))">
                <xsl:sequence select="$encodedUri"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Process the string recursively -->
                <xsl:sequence select="xat:uridecode-helper($encodedUri, '')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="xat:encoding.decodeURI">
        
        <xsl:param name="strItem"/>
        
        <!--
        <xsl:value-of select="java-urldecode:decode($strItem, 'UTF-8')"/>
        -->
        
        <xsl:value-of select="xat:uridecode($strItem)"/>
        
    </xsl:function>


    <!-- 
        ASCII
    -->

    <!-- A list of ASCII characters -->
    <xsl:function name="xat:encoding.strASCII">
        <xsl:variable name="strASCII">
            <xsl:text><![CDATA[&#00;&#01;&#02;&#03;&#04;&#05;&#06;&#07;&#08;&#09;]]></xsl:text>
            <xsl:text><![CDATA[&#10;&#11;&#12;&#13;&#14;&#15;&#16;&#17;&#18;&#19;]]></xsl:text>
            <xsl:text><![CDATA[&#20;&#21;&#22;&#23;&#24;&#25;&#26;&#27;&#29;&#29;]]></xsl:text>
            <xsl:text><![CDATA[&#30;&#21;]]></xsl:text>
            <xsl:text><![CDATA[ !"#$%&'()*+,-./0123456789:;<=>?@]]></xsl:text>
            <xsl:text><![CDATA[ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`]]></xsl:text>
            <xsl:text><![CDATA[abcdefghijklmnopqrstuvwxyz{|}~]]></xsl:text>
        </xsl:variable>
        <xsl:value-of select="$strASCII"/>
    </xsl:function>

    <!-- Removing ASCII characters from a string -->
    <xsl:function name="xat:encoding.removeASCII">
        <xsl:param name="strItem"/>
        <xsl:value-of select="translate($strItem, xat:encoding.strASCII(), '')"/>
    </xsl:function>

    <!-- Detecting ASCII characters -->
    <xsl:function name="xat:encoding.isASCII" as="xs:boolean">
        <xsl:param name="chrItem"/>
        <xsl:sequence select="contains(xat:encoding.strASCII(), $chrItem)"/>
    </xsl:function>


    <!-- 
        Detecting Unicode ranges
    -->

    <!-- Does a character match a range? -->
    <xsl:function name="xat:encoding.match" as="xs:boolean">
        <xsl:param name="chrA"/>
        <xsl:param name="chrX"/>
        <xsl:param name="chrZ"/>
        <xsl:sequence select="compare($chrA, $chrX) != 1 and compare($chrX, $chrZ) != 1"/>
    </xsl:function>

    <!-- A Unicode range is undefined by default -->
    <xsl:template match="*" mode="xat:encoding.range">
        <xsl:text>Undefined</xsl:text>
    </xsl:template>

    <!-- Basic Latin -->
    <xsl:template match="*[contains(xat:encoding.strASCII(), .)]" mode="xat:encoding.range">
        <xsl:text>Latin</xsl:text>
    </xsl:template>

    <!-- C1 Controls and Latin-1 Supplement -->
    <xsl:template match="*[xat:encoding.match('&#x0080;', ., '&#x00FF;')]" mode="xat:encoding.range">
        <xsl:text>Latin1</xsl:text>
    </xsl:template>

    <!-- Latin Extended-A -->
    <xsl:template match="*[xat:encoding.match('&#x0100;', ., '&#x017F;')]" mode="xat:encoding.range">
        <xsl:text>LatinA</xsl:text>
    </xsl:template>

    <!-- Latin Extended-B -->
    <xsl:template match="*[xat:encoding.match('&#x0180;', ., '&#x024F;')]" mode="xat:encoding.range">
        <xsl:text>LatinB</xsl:text>
    </xsl:template>

    <!-- Greek/Coptic -->
    <xsl:template match="*[xat:encoding.match('&#x0370;', ., '&#x03FF;')]" mode="xat:encoding.range">
        <xsl:text>Greek</xsl:text>
    </xsl:template>

    <!-- Cyrillic -->
    <xsl:template match="*[xat:encoding.match('&#x0400;', ., '&#x04FF;')]" mode="xat:encoding.range">
        <xsl:text>Cyrillic</xsl:text>
    </xsl:template>

    <!-- Hebrew -->
    <xsl:template match="*[xat:encoding.match('&#x0590;', ., '&#x05FF;')]" mode="xat:encoding.range">
        <xsl:text>Hebrew</xsl:text>
    </xsl:template>

    <!-- Detecting a Unicode range for a character -->
    <xsl:function name="xat:encoding.range">
        <xsl:param name="chrItem"/>
        <xsl:variable name="xmlChar">
            <char>
                <xsl:value-of select="$chrItem"/>
            </char>
        </xsl:variable>
        <xsl:apply-templates select="$xmlChar/char" mode="xat:encoding.range"/>
    </xsl:function>

    <!-- Detecting a Unicode range for a string -->
    <xsl:function name="xat:encoding.strRange">
        <xsl:param name="strItem"/>
        <xsl:variable name="strNonASCII" select="xat:encoding.removeASCII($strItem)"/>
        <xsl:choose>
            <xsl:when test="$strNonASCII = ''">
                <xsl:text>Latin</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="xat:encoding.range(substring($strNonASCII, 1, 1))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- Representing a string as a sequence of characters -->
    <xsl:function name="xat:encoding.sequence" as="xs:string*">
        <xsl:param name="strItem"/>
        <xsl:analyze-string select="$strItem" regex=".">
            <xsl:matching-substring>
                <xsl:value-of select="."/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>

</xsl:stylesheet>
