<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %> 
<%@ taglib uri="http://sakaiproject.org/jsf/sakai" prefix="sakai" %>
<f:loadBundle basename="es.udl.asic.sakaiproject.tool.einahelpdesk.Messages" var="msgs"/>

<f:view>

	<sakai:view_container title="#{msgs.sample_title2}" rendered="#{HDesk.perfil=='operador'}">
	<h:form >
	
	<jsp:include page="toolbar.jsp" /> <br>
		 
	<table width="95%" align="center" cellpadding=0 cellspacing=0 border=0>
        <tr><td align="center">
        <h3>       
		<f:attribute name="res" value="#{HDesk_operador.isHistoric}" /> 
                <c:choose>
                <c:when test="${HDesk_operador.isHistoric==0}">
                	Assist&egrave;ncies actives o resoltes assignades
		</c:when>
              	<c:when test="${HDesk_operador.isHistoric==2}">
                	Consulta de l'hist&ograve;ric de tota la UdL       
		</c:when>
              	<c:otherwise>
		</c:otherwise>
                </c:choose> 
	</h3>   
               
        </td></tr>
        <tr><td>
		<table width="100%" bgcolor="#f0f0f0" border=0>                
                <tr><td valign="bottom">
                	<h:outputText value="#{msgs.operador}" /> 
                	<h:outputText value="#{HDesk_operador.nom}" style="font-weight: bold; font-size: 15;"/><br><br> 
                	<h:outputText value="#{msgs.cerca}"/>     
                	<h:selectOneMenu value="#{HDesk_operador.columna_sel}" required="false" >
				<f:selectItems value="#{HDesk_operador.columna_cerca}"/>
			</h:selectOneMenu>
                	<h:outputText value="#{msgs.clau}" />
                	<h:inputText value="#{HDesk_operador.paraula_clau}" size="15" /></td><td valign="bottom">
                	<sakai:button_bar>
				<sakai:button_bar_item value="#{msgs.boto_cercar}" action="#{HDesk_operador.processActionCercar}"/>
				<sakai:button_bar_item value="#{msgs.boto_netejar}" action="#{HDesk_operador.processActionNeteja}" />		
				 <sakai:button_bar_item value="#{msgs.boto_informe}" action="#{HDesk_operador.imprimeixAssistencies}" rendered="#{HDesk_operador.isHistoric==0}"/>
 			</sakai:button_bar>
                </td></tr><tr>
                <td valign="bottom">
               	<sakai:button_bar>
			<sakai:button_bar_item value="|<" action="#{HDesk_operador.processActionPrimeraPag}" disabled="#{HDesk_operador.noTePrevia}"/>
			<sakai:button_bar_item value="<" action="#{HDesk_operador.processActionPagAnt}" disabled="#{HDesk_operador.noTePrevia}"/>
	           	<h:selectOneMenu valueChangeListener="#{HDesk_operador.setReg_per_pag}"  value="#{HDesk_operador.reg_per_pag}" onchange="submit()"  immediate="true" style="background:#f8ffbe">
				<f:selectItem itemLabel="mostrar 5 per pagina" itemValue="5"/>
				<f:selectItem itemLabel="mostrar 10 per pagina" itemValue="10"/>
				<f:selectItem itemLabel="mostrar 20 ..." itemValue="20"/>
				<f:selectItem itemLabel="mostrar 50 ..." itemValue="50"/>
			</h:selectOneMenu>
                     	<sakai:button_bar_item value=">" action="#{HDesk_operador.processActionPagSeg}" disabled="#{HDesk_operador.noTeSeg}"/>
			<sakai:button_bar_item value=">|" action="#{HDesk_operador.processActionUltimaPag}" disabled="#{HDesk_operador.noTeSeg}"/>
		</sakai:button_bar>
                
		</td><td align="right">
                <h:outputText value="#{HDesk_operador.pagina} de #{HDesk_operador.totalPag}"/>
                </td></tr></table></td></tr></table>
                
		  <table width="95%" align="center" cellpadding=0 cellspacing=-1 border=0>
                  <tr><td><p align="justify">
                
                    <table width="100%" >
                                
                    <tr><td>
		    <%--<sakai:flat_list value="#{HDesk_operador.assistencies}" var="registre" >--%>		
		    <h:dataTable styleClass="table table-striped" value="#{HDesk_operador.assistencies}" bgcolor="#ffffff" border="0" cellpadding="4" cellspacing="1" var="registre" headerClass="presenceList" rowClasses="borderGrayBackground,borderWhite" >
       			<h:column>
       				<f:facet name="header">
					<h:commandLink action="#{HDesk_operador.mouSentit1}">
					<h:outputText value="#{msgs.text_cons_assist1}" style="font-weight:bold;font-size:8pt;"/>                                    				     <h:graphicImage value="/image/#{HDesk_operador.amuntavallres1}" />
			  		</h:commandLink> 
				</f:facet>
			  		
			  	<h:commandLink action="#{HDesk_operador.processActionAssisOperador}" actionListener="#{HDesk_operador.processActionViewTicket}" value="#{registre.ticket}" immediate="true" >
				<f:param name="ticket" value="#{registre.ticket}" />
     				</h:commandLink>
		  	</h:column>

          		<h:column>
		  		<f:facet name="header">
					<h:commandLink action="#{HDesk_operador.mouSentit2}"> 
		  			<h:outputText value="#{msgs.text_cons_assist2}" style="font-weight:bold;font-size:8pt"/>                                       				     <h:graphicImage value="/image/#{HDesk_operador.amuntavallres2}" />
			  		</h:commandLink> 
				</f:facet>
		  	<h:outputText value="#{registre.strData_inici}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.strData_inici}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
			<h:outputText value="#{registre.strData_inici}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.strData_inici}" style="font-weight:bold;" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>	
			<h:outputText value="#{registre.strData_inici}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
			<h:outputText value="#{registre.strData_inici}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.strData_inici}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.strData_inici}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>
		  			
		  	<h:column>
		  		<f:facet name="header">
					<h:commandLink action="#{HDesk_operador.mouSentit3}"> 
		  			<h:outputText value="#{msgs.text_cons_assist3}" style="font-weight:bold;font-size:8pt"/>                                       				     <h:graphicImage value="/image/#{HDesk_operador.amuntavallres3}" />
			  		</h:commandLink> 
		  		</f:facet>
		  	<h:outputText value="#{registre.nom_usuari}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
		  	<h:outputText value="#{registre.nom_usuari}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_usuari}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_usuari}" style="font-weight:bold;" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_usuari}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_usuari}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_usuari}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
			 <h:outputText value="#{registre.nom_usuari}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
		  	</h:column>		  			  

			 <h:column>
				<f:facet name="header">
                                	<h:outputText value="#{msgs.text_cons_assist10}" style="font-weight:bold; font-size:8pt; color:#3355bb"/>            				     </f:facet>
                        <h:outputText value="#{registre.telefon}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
                        <h:outputText value="#{registre.telefon}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.telefon}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.telefon}" style="font-weight:bold;" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
                        <h:outputText value="#{registre.telefon}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.telefon}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.telefon}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
                         <h:outputText value="#{registre.telefon}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>

		  	<h:column>
		  		<f:facet name="header">
					<h:commandLink action="#{HDesk_operador.mouSentit4}"> 
		  			<h:outputText value="#{msgs.text_cons_assist4}" style="font-weight:bold;font-size:8pt"/>
		  			<h:graphicImage value="/image/#{HDesk_operador.amuntavallres4}" />
					</h:commandLink> 
		  		</f:facet>
	  		<h:outputText value="#{registre.nom_campus}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.nom_campus}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_campus}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_campus}" style="font-weight:bold;" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_campus}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_campus}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_campus}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
			 <h:outputText value="#{registre.nom_campus}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>
	  		
			<h:column>
		  		<f:facet name="header">
					<h:commandLink action="#{HDesk_operador.mouSentit5}"> 
		  			<h:outputText value="#{msgs.text_cons_assist5}" style="font-weight:bold;font-size:8pt"/>
		  			<h:graphicImage value="/image/#{HDesk_operador.amuntavallres5}" />
					</h:commandLink> 
				</f:facet>
		  	<h:outputText value="#{registre.nom_edifici}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.nom_edifici}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_edifici}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_edifici}" style="font-weight:bold" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_edifici}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_edifici}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_edifici}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)  || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
		  	 <h:outputText value="#{registre.nom_edifici}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>
				
			<h:column>
		  		<f:facet name="header">
					<h:commandLink action="#{HDesk_operador.mouSentit6}"> 
		  			<h:outputText value="#{msgs.text_cons_assist6}" style="font-weight:bold;font-size:8pt"/>                                       				     <h:graphicImage value="/image/#{HDesk_operador.amuntavallres6}" />
			  		</h:commandLink> 
		  		</f:facet>
			<h:outputText value="#{registre.nom_tecnic}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.nom_tecnic}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_tecnic}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_tecnic}" style="font-weight:bold" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_tecnic}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
		  	<h:outputText value="#{registre.nom_tecnic}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_tecnic}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_tecnic}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>

			<h:column>
		  		<f:facet name="header">
        				<h:commandLink action="#{HDesk_operador.mouSentit7}"> 
          				<h:outputText value="#{msgs.text_cons_assist7}" style="font-weight:bold;font-size:8pt"/>
		  			<h:graphicImage value="/image/#{HDesk_operador.amuntavallres7}" />
					</h:commandLink> 
		  		</f:facet>
			<h:outputText value="#{registre.nom_categoria}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.nom_categoria}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_categoria}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_categoria}" style="font-weight:bold" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_categoria}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
		   	<h:outputText value="#{registre.nom_categoria}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_categoria}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_categoria}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>
		  	
		  	<h:column>
		  		<f:facet name="header">
        			<h:commandLink action="#{HDesk_operador.mouSentit8}"> 
           			<h:outputText value="#{msgs.text_cons_assist8}" style="font-weight:bold;font-size:8pt"/>
		  		<h:graphicImage value="/image/#{HDesk_operador.amuntavallres8}" />
				</h:commandLink> 
		  		</f:facet>
			<h:outputText value="#{registre.nom_prioritat}"  rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.nom_prioritat}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_prioritat}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_prioritat}" style="font-weight:bold" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_prioritat}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_prioritat}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_prioritat}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_prioritat}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>
			
			<c:choose>
				<c:when test="${HDesk_operador.isHistoric==0}">
					<h:column>
		  				<f:facet name="header">
        					<h:commandLink action="#{HDesk_operador.mouSentit9}"> 
           					<h:outputText value="#{msgs.text_cons_assist9}" style="font-weight:bold;font-size:8pt"/>
		  				<h:graphicImage value="/image/#{HDesk_operador.amuntavallres9}" />
			  			</h:commandLink> 
		
				  		</f:facet>
			<h:outputText value="#{registre.nom_estat}" rendered="#{(registre.estat==0 && registre.estat_activa==0) || registre.estat==2}"/>
			<h:outputText value="#{registre.nom_estat}" style="color:red" rendered="#{registre.estat==0 && registre.estat_activa==1 && registre.id_tecnic==HDesk_operador.userId }"/>
                        <h:outputText value="#{registre.nom_estat}" style="color:black" rendered="#{registre.estat==0 && (registre.estat_activa==1 || registre.estat_activa==3) && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_estat}" style="font-weight:bold" rendered="#{registre.estat==1 && registre.estat_activa==0}"/>
			<h:outputText value="#{registre.nom_estat}" style="font-weight:bold; color:red" rendered="#{((registre.estat==0 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2)) && registre.id_tecnic==HDesk_operador.userId }"/>					
			<h:outputText value="#{registre.nom_estat}" style="color:black" rendered="#{registre.estat==0 && registre.estat_activa==2 && registre.id_tecnic!=HDesk_operador.userId }"/>
			<h:outputText value="#{registre.nom_estat}" style="font-weight:bold; color:black" rendered="#{((registre.estat==1 && registre.estat_activa==1) || (registre.estat==1 && registre.estat_activa==2) || (registre.estat==1 && registre.estat_activa==3)) && registre.id_tecnic!=HDesk_operador.userId }"/>
 			<h:outputText value="#{registre.nom_estat}" style="color:green" rendered="#{(registre.estat==0 || registre.estat==1) && registre.estat_activa==3 && registre.id_tecnic==HDesk_operador.userId }"/>
			</h:column>
		  		</c:when>
		  		<c:otherwise>
		  		</c:otherwise>
		  	</c:choose>
		     <%--</sakai:flat_list>--%>
                     </h:dataTable>    
                     </td></tr>
		        		       		        
		     </table>
         		
         	</p></td></tr>
         	</table>
             </td></tr>
          </table>
		  	    
	</h:form>	
	
	</sakai:view_container>
	<sakai:view_container rendered="#{HDesk.perfil!='operador'}">
		<center><br><br>
				 <h:outputText style="font-weight:bold;color:red;" value="Error:"/> <h:outputText value="#{msgs.error}" /><br>
	   </center>
	</sakai:view_container>
	

</f:view>
