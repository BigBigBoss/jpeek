<?xml version="1.0"?>
<!--
The MIT License (MIT)

Copyright (c) 2017 Yegor Bugayenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="2.0">
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta name="description" content="jpeek metric"/>
        <meta name="keywords" content="code quality metrics"/>
        <meta name="author" content="jpeek.org"/>
        <link rel="shortcut icon" href="http://www.jpeek.org/logo.png"/>
        <link rel="stylesheet" href="http://cdn.rawgit.com/yegor256/tacit/gh-pages/tacit-css-1.1.1.min.css"/>
        <link rel="stylesheet" href="jpeek.css"/>
        <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/sortable/0.8.0/js/sortable.min.js">&#xA0;</script>
        <title>
          <xsl:value-of select="title"/>
        </title>
      </head>
      <body>
        <xsl:apply-templates select="metric"/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="metric">
    <p>
      <a href="http://i.jpeek.org">
        <img alt="logo" src="http://www.jpeek.org/logo.svg" style="height:60px"/>
      </a>
    </p>
    <p>
      <a href="index.html">
        <xsl:text>Back to index</xsl:text>
      </a>
    </p>
    <h1>
      <xsl:value-of select="title"/>
    </h1>
    <p>
      <xsl:text>"Yellow" zone: </xsl:text>
      <code>
        <xsl:value-of select="colors"/>
      </code>
      <xsl:text>.</xsl:text>
    </p>
    <xsl:apply-templates select="app/@value"/>
    <p>
      <xsl:text>Packages: </xsl:text>
      <xsl:value-of select="count(//package)"/>
      <xsl:text>, classes: </xsl:text>
      <xsl:value-of select="count(//class)"/>
      <xsl:text>, average: </xsl:text>
      <xsl:choose>
        <xsl:when test="//class">
          <xsl:value-of select="format-number(sum(//class/@value) div count(//class), '0.0000')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>.</xsl:text>
    </p>
    <p>
      <xsl:text>Green: </xsl:text>
      <xsl:value-of select="count(//class[@color='green'])"/>
      <xsl:text>, yellow: </xsl:text>
      <xsl:value-of select="count(//class[@color='yellow'])"/>
      <xsl:text>, red: </xsl:text>
      <xsl:value-of select="count(//class[@color='red'])"/>
      <xsl:text>.</xsl:text>
    </p>
    <xsl:apply-templates select="app"/>
    <footer style="color:gray;font-size:75%;">
      <p>
        <xsl:text>This report was generated by </xsl:text>
        <a href="http://www.jpeek.org">
          <xsl:text>jpeek </xsl:text>
          <xsl:value-of select="@version"/>
        </a>
        <xsl:text> on </xsl:text>
        <xsl:value-of select="@date"/>
        <xsl:text>.</xsl:text>
      </p>
    </footer>
  </xsl:template>
  <xsl:template match="app/@value">
    <p>
      <xsl:text>App measurement: </xsl:text>
      <code>
        <xsl:value-of select="."/>
      </code>
      <xsl:text>.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="app[not(package)]">
    <p>
      <xsl:text>No measurements for packages.</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="app[package]">
    <table data-sortable="true">
      <colgroup>
        <col/>
        <col/>
      </colgroup>
      <thead>
        <tr>
          <th>
            <xsl:text>ID</xsl:text>
          </th>
          <th style="text-align:right">
            <xsl:text>Value</xsl:text>
          </th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="package"/>
      </tbody>
    </table>
  </xsl:template>
  <xsl:template match="package">
    <xsl:if test="@value">
      <tr>
        <td>
          <code>
            <strong>
              <xsl:value-of select="@id"/>
            </strong>
          </code>
        </td>
        <td style="text-align:right">
          <xsl:value-of select="@value"/>
        </td>
      </tr>
    </xsl:if>
    <xsl:apply-templates select="class"/>
  </xsl:template>
  <xsl:template match="class">
    <tr>
      <td>
        <code title="{../@id}.{@id}">
          <xsl:value-of select="replace(../@id, '([a-z])[a-z0-9\$]+\.', '$1.')"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="replace(@id, '([A-Z])[A-Za-z0-9]+\$', '$1..\$')"/>
        </code>
      </td>
      <td>
        <xsl:if test="@color">
          <xsl:attribute name="style">
            <xsl:text>text-align:right;</xsl:text>
            <xsl:text>color:</xsl:text>
            <xsl:choose>
              <xsl:when test="@color='red'">
                <xsl:text>red</xsl:text>
              </xsl:when>
              <xsl:when test="@color='green'">
                <xsl:text>green</xsl:text>
              </xsl:when>
              <xsl:when test="@color='yellow'">
                <xsl:text>orange</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>inherit</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@value"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
