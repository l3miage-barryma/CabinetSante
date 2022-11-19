<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : infirmiere.xsl
    Created on : 16 novembre 2021, 15:41
    Author     : riamb
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:med="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'
                version="1.0">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:param name="destinedId" select="001"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>infirmiere.xsl</title>
                <link rel="stylesheet" href="cv.css"/>
                <script type="text/javascript">
function openFacture(prenom, nom, actes) {
   var width  = 500;
   var height = 300;
   if(window.innerWidth) {
       var left = (window.innerWidth-width)/2;
       var top = (window.innerHeight-height)/2;
   }
   else {
       var left = (document.body.clientWidth-width)/2;
       var top = (document.body.clientHeight-height)/2;
   }
   var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
   factureText = "Facture pour : " + prenom + " " + nom;
   factureWindow.document.write(factureText);
} 
                </script>
                <link rel="stylesheet" href="cv.css"/>
            </head>
            <body>
                <!-- afficher "Bonjour <prénom>" -->
                <xsl:value-of select="/med:cabinet/med:nom"/>
                <p>Bonjour <xsl:value-of select="/med:cabinet/med:infirmiers/med:infirmier[@id = '001']/med:prénom" />,</p>
                <!-- afficher "Aujourd'hui, vous avez <N> patients" -->
                <xsl:variable name="visitesDuJour" select="/med:cabinet/med:patients/med:patient/med:visite[@intervenant = $destinedId]" />
                <p>Aujourd'hui, vous avez <xsl:value-of select="count($visitesDuJour)" /> patient<xsl:if test="count($visitesDuJour)&gt;1">s</xsl:if>.</p>
                
                <!-- liste des patients -->
                <xsl:apply-templates select="$visitesDuJour/.." >
                    <xsl:sort select="med:visite/@date" order="ascending" />
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template patient -->
    <xsl:template match="med:patient">
        <h4><xsl:value-of select="med:prénom" /><xsl:text> </xsl:text><xsl:value-of select="nom" /> </h4>
        <p>
            <xsl:if test="med:adresse/med:étage">
                Etage n°<xsl:value-of select="med:adresse/med:étage" /><br/>
            </xsl:if>
            <xsl:if test="med:adresse/med:numéro">
                <xsl:value-of select="med:adresse/med:numéro" />,
            </xsl:if>
            <xsl:value-of select="med:adresse/med:rue" />
            <br/>
            <xsl:value-of select="med:adresse/med:codePostal"/><xsl:text> </xsl:text><xsl:value-of select="med:adresse/med:ville" />
        </p>
        <ul>
            <xsl:apply-templates select="med:visite/med:acte" />
        </ul>
        <xsl:element name="input">
            <xsl:attribute name="type">button</xsl:attribute>
            <xsl:attribute name="value">Facture</xsl:attribute>
            <xsl:attribute name="onclick">
                openFacture('<xsl:value-of select="med:prénom"/>', 
                            '<xsl:value-of select="med:nom"/>', 
                            '<xsl:value-of select="med:visite/med:acte"/>')
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- Template visite -->
    
    <!-- Template acte -->
    <xsl:template match="med:acte">
        <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
        <xsl:variable name="idActe" select="@id" />
        <li>
            <xsl:value-of select="$actes/act:actes/act:acte[@id=$idActe]/text()" />
        </li>
    </xsl:template>

</xsl:stylesheet>
