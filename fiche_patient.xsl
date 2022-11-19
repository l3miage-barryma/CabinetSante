<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : fiche_patient.xsl
    Created on : 19 novembre 2021, 11:50
    Author     : riamb
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
   
    <xsl:template match="/">
        <html>
            <head>
                <title>Fiche <xsl:value-of select="/patient/nom" /></title>
                <link rel="stylesheet" href="cv.css"/>
            </head>
            <body>
                <h1>
                    <xsl:value-of select="/patient/prénom" />
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="/patient/nom" />
                </h1>
                <p>
                    Né<xsl:if test="/patient/sexe = 'F'" >e</xsl:if>
                    <xsl:text> le </xsl:text>
                    <xsl:value-of select="/patient/naissance" />
                </p>
                <p>
                    Numéro de sécu : <xsl:value-of select="/patient/numéroSS" />
                </p>
                <h3>Visites</h3>
                <table>
                    <tr>
                        <th>
                            date
                        </th>
                        <th>
                            acte
                        </th>
                        <th>
                            intervenant
                        </th>
                    </tr>
                    <xsl:apply-templates select="/patient/visite/acte" />
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="acte" >
        <tr>
            <td>
                <xsl:value-of select="../@date"/>
            </td>
            <td>
                <xsl:value-of select="text()"/>
            </td>
            <td>
                <xsl:value-of select="../intervenant/prénom"/>
                <xsl:value-of select="../intervenant/nom"/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
