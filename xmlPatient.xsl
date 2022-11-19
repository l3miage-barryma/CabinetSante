<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : xmlPatient.xsl
    Created on : 16 novembre 2021, 17:29
    Author     : chaym
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:med="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'
                version="1.0">
    <xsl:output method="xml"/>
    
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:param name="destinedName" select="'Pien'"/>
    
    <xsl:template match="/">
        <patient>
        <xsl:variable name="lePatient" select="/med:cabinet/med:patients/med:patient[med:nom/text() = $destinedName]" />
            <nom><xsl:value-of select="$lePatient/med:nom" /></nom>
            <prénom><xsl:value-of select="$lePatient/med:prénom/text()" /></prénom>
            <sexe><xsl:value-of select="$lePatient/med:sexe/text()" /></sexe>
            <naissance><xsl:value-of select="$lePatient/med:naissance/text()" /></naissance>
            <numéroSS><xsl:value-of select="$lePatient/med:numéro/text()" /></numéroSS>
            <adresse>
                <xsl:if test="$lePatient/med:adresse/med:étage">
                    <étage><xsl:value-of select="$lePatient/med:adresse/med:étage/text()" /></étage>
                </xsl:if>
                <xsl:if test="$lePatient/med:adresse/med:numéro">
                    <numéro><xsl:value-of select="$lePatient/med:adresse/med:numéro/text()" /></numéro>
                </xsl:if>
                <rue><xsl:value-of select="$lePatient/med:adresse/med:rue/text()" /></rue>
                <codePostal><xsl:value-of select="$lePatient/med:adresse/med:codePostal/text()" /></codePostal>
                <ville><xsl:value-of select="$lePatient/med:adresse/med:ville/text()" /></ville>
            </adresse>
            <xsl:apply-templates select="$lePatient/med:visite" >
                <xsl:sort select="@date" order="ascending"/>
            </xsl:apply-templates>
        </patient>
    </xsl:template>
    
    <!-- template visite -->
    <xsl:template match="med:visite">
        <xsl:variable name="inter" select="@intervenant"/>
        <xsl:element name="visite">
            <xsl:attribute name="date">
                <xsl:value-of select="@date" />
            </xsl:attribute>
            <xsl:apply-templates select="/med:cabinet/med:infirmiers/med:infirmier[@id = $inter]" />
            <xsl:apply-templates select="med:acte" />
        </xsl:element>
    </xsl:template>

    
    <xsl:template match="med:infirmier">
        <xsl:element name="intervenant">
            <nom><xsl:value-of select="med:nom" /></nom>
            <prénom><xsl:value-of select="med:prénom" /></prénom>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="med:acte">
        <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
        <xsl:variable name="idActe" select="@id" />
        <acte>
            <xsl:value-of select="$actes/act:actes/act:acte[@id=$idActe]/text()" />
        </acte>
    </xsl:template>
</xsl:stylesheet>
