package es.udl.asic.component.app.actes;

//import org.sakaiproject.service.legacy.resource.ResourceProperties;
//import org.sakaiproject.service.legacy.time.Time;
//import org.sakaiproject.service.legacy.user.User;
//import org.sakaiproject.service.legacy.realm.cover.RealmService;
//im/ort org.sakaiproject.service.legacy.realm.Realm;
//import org.sakaiproject.service.legacy.realm.RealmEdit;
///import org.sakaiproject.service.legacy.user.UserDirectoryProvider;
//import org.sakaiproject.javax.PagingPosition;

import es.udl.asic.api.app.actes.Actes;
import es.udl.asic.api.app.actes.Qualificacions;
import es.udl.asic.api.app.actes.Qualificacio;
import es.udl.asic.api.app.actes.Acta;
import es.udl.asic.api.app.actes.LiniaActaServ;
import es.udl.asic.api.app.actes.InfoAssig;

import java.util.List;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.Iterator;
import java.util.Properties;


import javax.sql.DataSource;
import java.sql.*;
import java.util.*;

import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.PoolingDataSource;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
/**
 * 
 * @author ASIC - Alex
 *
 *  Implementacio de la interfici actes.
 */

public class ActesImpl implements Actes {
	
	
	
	private 
		String driver="";
		DataSource ds = null;
		String db=""; 
		ObjectPool connectionPool=null;
		
		
		/* SQL que retorna la llista d'actes d'un any, d'una assig 
		 * i un professor en concret*/ 
		
		// CANVIS CODI 18 Gener
		// eliminem el filtre per any acadèmic
		// les consultes que filtren queden amb _OLD
		String SQL_LLISTA_ACTES_OLD= 
				"SELECT ACT.ANY_ANYACA, ACT.TCO_CODALF,"+
				" ACT.NOMTCO, ACT.ASS_CODNUM,ACT.NOMASS," +
				" ACT.GAS_CODNUM, ACT.NOMGAS, ACT.ACT_NUMORD,"+
				" ACT.ORDEN,ACT.PRF_DNIPRF, ACT.DATOBE,"+ 
				" ACT.FLGTANDFI, ACT.TQU_CODALF,ACT.FLGTANPRF,"+
				"DECODE (ACT.FLGVIS,'S','X',NULL) FLGVIS,"+
				"ACT.OBSERVACION FROM VRC_ACTA ACT WHERE ACT.PRF_DNIPRF =?" +
				" AND ACT.ANY_ANYACA=?" +
				" AND ACT.ASS_CODNUM=?";
		
		
		String SQL_LLISTA_ACTES= 
			"SELECT ACT.ANY_ANYACA, ACT.TCO_CODALF,"+
			" ACT.NOMTCO, ACT.ASS_CODNUM,ACT.NOMASS," +
			" ACT.GAS_CODNUM, ACT.NOMGAS, ACT.ACT_NUMORD,"+
			" ACT.ORDEN,ACT.PRF_DNIPRF, ACT.DATOBE,"+ 
			" ACT.FLGTANDFI, ACT.TQU_CODALF,ACT.FLGTANPRF,"+
			"DECODE (ACT.FLGVIS,'S','X',NULL) FLGVIS,"+
			"ACT.OBSERVACION FROM VRC_ACTA ACT WHERE ACT.PRF_DNIPRF =?" +
			" AND ACT.ASS_CODNUM=?";
		
		String SQL_LLISTA_ACTES_ALL_OLD= 
			"SELECT ACT.ANY_ANYACA, ACT.TCO_CODALF,"+
			" ACT.NOMTCO, ACT.ASS_CODNUM,ACT.NOMASS," +
			" ACT.GAS_CODNUM, ACT.NOMGAS, ACT.ACT_NUMORD,"+
			" ACT.ORDEN,ACT.PRF_DNIPRF, ACT.DATOBE,"+ 
			" ACT.FLGTANDFI, ACT.TQU_CODALF,ACT.FLGTANPRF,"+
			"DECODE (ACT.FLGVIS,'S','X',NULL) FLGVIS,"+
			"ACT.OBSERVACION FROM VRC_ACTA ACT WHERE ACT.PRF_DNIPRF =?" +
			" AND ACT.ANY_ANYACA=?";
		
		String SQL_LLISTA_ACTES_ALL= 
			"SELECT ACT.ANY_ANYACA, ACT.TCO_CODALF,"+
			" ACT.NOMTCO, ACT.ASS_CODNUM,ACT.NOMASS," +
			" ACT.GAS_CODNUM, ACT.NOMGAS, ACT.ACT_NUMORD,"+
			" ACT.ORDEN,ACT.PRF_DNIPRF, ACT.DATOBE,"+ 
			" ACT.FLGTANDFI, ACT.TQU_CODALF,ACT.FLGTANPRF,"+
			"DECODE (ACT.FLGVIS,'S','X',NULL) FLGVIS,"+
			"ACT.OBSERVACION FROM VRC_ACTA ACT WHERE ACT.PRF_DNIPRF =?";
		// FI CANVIS CODI 18 Gener
		
		/* SQL que retorna el dni del professor per un determinat login*/
		
		//String SQL_DNI = "SELECT NIF FROM VUDL_RC_LOGIN_NIF WHERE LOGIN =?";
		String SQL_DNI = "SELECT PRS_DNIPRS FROM VUDL_LOGIN_PRFS WHERE LOGIN =?";
		
		/* SQL que retorna les linies de les actes d'una acta especifica*/
		
		String SQL_ACTA_ACTUAL_LINIES = "select vaml.any_anyaca, vaml.tco_codalf, " +
					"vaml.ass_codnum, vaml.gas_codnum, vaml.act_numord, vaml.dnialu, " +
					"vaml.nombre, vaml.pla_codalf, vaml.nompla, vaml.qua_codalf, " +
					"vaml.quanum, vaml.flgblo, vaml.exp_numord, vaml.tiplin, vaml.flganu," +
					" vaml.flgtan, vaml.flgaca, vaml.pac_codnum, vaml.tqu_codalf, " +
					"vaml.nomtqu, vaml.pla_codalfmat,  " +
					"alu$ulac.ConvocatoriesExhaurides(vaml.pla_codalf,vaml.exp_numord,vaml.ass_codnum) " +
					"as numcon, vaml.tas_codalf, vaml.nomtas, vaml.flginc from VRC_LINACTA vaml " +
					"WHERE 	vaml.ANY_ANYACA   = ? AND	" +
					"vaml.ACT_NUMORD	= ? AND	" +
					"vaml.ASS_CODNUM	= ? AND	" +
					"vaml.GAS_CODNUM	= ? AND "+
					"vaml.TCO_CODALF	= ? "+
					"order by nombredup, vaml.dnialu";
			
		/*Retorna la llista de qualificacions*/
		
		String SQL_NOTES = "SELECT cbr.QUA_CODALF, qua.NOMQUA, " +
					"cbr.RANMIN, cbr.RANMAX, qua.AFIQUANUM FROM " +
					"TALU_CPSBAREM  cbr, VALU_QUALIFICACIO qua " +
					"WHERE cbr.QUA_CODALF = qua.CODALF AND qua.FLGPRF = 'S' AND " +
					"cbr.BAR_CODALF = 'CON' ORDER BY cbr.RANMIN";

			
	
	
	/*********************Metodes *******************/	
		
	public void shutdown(){
		//System.out.println ("Parem les connexions");
          if (connectionPool!= null){
                  try{
                	  connectionPool.close();
                      //System.out.println("He tancat el pool");
                  }catch(Exception ex){
                	  System.out.println("No s'ha pogut tancar el pool");
                  }
          }
	}
		
		
		
	//Retorna la llista d'actes d'un professor en un any i d'una assignatura*/
	
	public List getLlistaActes(String cod_ass,String dni,String any_acad){

		// Obtenim la connexio
		Connection conn = getConnection();
		
		//Creem la llista de retorn
		List llista = new ArrayList();
		
		
		CallableStatement call = null;
		
		try{
			//Inicialitzem la crida
			call = conn.prepareCall("{call uib$uini.inicialitzar}");
			call.executeUpdate();	

			//Preparem la comanda SQL
			if (cod_ass.equals("toteslesactes")){//Si és un lloc genèric no mirem el codi de l'assignatura
				call = conn.prepareCall(SQL_LLISTA_ACTES_ALL);
			}else{
				call = conn.prepareCall(SQL_LLISTA_ACTES);
			}
				
			

			// Carreguem els paràmetres 
			
			call.setString(1,dni); 
			// CANVIS CODI 18 Gener
			// call.setString(2,any_acad); 
			// No filtrem per any acadèmic
			// per recuperar-lo cal tocar aquest codi i fer servir les consultes antigues
			// FI CANVIS CODI 18 Gener
			if (!cod_ass.equals("toteslesactes")){//Nomes carreguem el codi d'assignatura si aquest és pregunta en un espai curs
				// CANVIS CODI 18 Gener
				// el segon paràmetre passa a ser cod_ass, tot i que usualment no s'executa
				// call.setString(3,cod_ass);
				call.setString(2,cod_ass);
				// FI CANVIS CODI 18 Gener
			}

			// Carreguem les dades a la llista de retorn

			ResultSet rst = call.executeQuery();
			System.out.println("Despres de l'execute");
			
			while (rst.next()){
				Acta act = new Acta(rst.getString(1),rst.getInt(4),rst.getString(5),rst.getInt(6),rst.getString(7),rst.getInt(8),rst.getString(10),rst.getString(2),rst.getString(3));
				llista.add(act);
			}
			
			// Tanquem els objectes oberts
			rst.close();
			call.close();
			
		}catch (Exception ex){
			System.out.println("Error al obtindre la llista d'actes");
		}
			// Retornem la connexio
		returnConnection(conn);
	
		return llista;
	}
	
	
	public List getLlistaLinies(Acta acta){

		// Obtenim la connexio
		Connection conn = getConnection();
		List llista = new ArrayList();
		
		CallableStatement call = null;
		
		try{
			call = conn.prepareCall("{call uib$uini.inicialitzar}");
			call.executeUpdate();	

			call = conn.prepareCall(SQL_ACTA_ACTUAL_LINIES);

			// Carreguem els paràmetres
			
			call.setString(1,acta.getAnyaca()); //Anyaca
			call.setInt(2,acta.getNumord());
			call.setInt(3,acta.getAss_codnum());
			call.setInt(4,acta.getGas_codnum());
			call.setString(5,acta.getTco_codalf());
			
			// Carreguem les dades a la llista de retorn
			ResultSet rst = call.executeQuery();
			
			
			while (rst.next()){
				//Creem la linia d'acta
				String nota = rst.getString(11);
				//System.out.println("la nota es " + nota);

				if (nota != null){
					if (nota.startsWith(".")){
						nota= "0" + nota;
					}
				}
				
				LiniaActaServ las = new LiniaActaServ(
					rst.getString(1),
					rst.getString(2),
					rst.getInt(3),
					rst.getInt(4),
					rst.getInt(5),
					rst.getString(6),
					rst.getString(7),
					rst.getString(8),
					rst.getString(9),
					rst.getString(10),
					nota,
					rst.getString(13),
					rst.getString(22),
					rst.getString(24),
					rst.getString(19),
					rst.getString(18),
					rst.getString(21)
				);
				//Afegim la linia a la llista
				llista.add(las);
			}
			
			//Tanquem els objectes oberts
			rst.close();
			call.close();
			
		}catch (Exception ex){
			ex.printStackTrace();
			System.out.println("Error al obtindre la llista d'actes");
		}
		
		//Retornem la connexio
		returnConnection(conn);
	
		//Retornem la llista
		return llista;
	}

	/*
	 * Crea l'estructura de qualificacions
	 * 
	 */
	
	public Qualificacions getQualificacions(){
		Connection conn = getConnection();

		Qualificacions qual = new Qualificacions();
	
		try{
			Statement stmt = conn.createStatement();
			ResultSet rst = stmt.executeQuery(SQL_NOTES);
			
			qual.inicialitzaLlista();
			
			while (rst.next()){
				qual.afergirQuali(rst.getString(1),rst.getString(2),rst.getString(3),rst.getString(4),rst.getString(5));
			}

			rst.close();	
			stmt.close();
		}catch (Exception ex){
			System.out.println("Error al obtindre les notes");
		}
		
		returnConnection(conn);
		return qual;
	}
	
	
	
	/*
	 * Transforma el codi de l'assignatura en un array de Strings on  
	 * està 
	 * 
	 */
	
	public String getDni(String login){
		//Obtenim la connexio
		Connection conn = getConnection();
		String dni="";
		
		
		List llista = new ArrayList();
		CallableStatement call = null;
		
		try{
			call = conn.prepareCall("{call uib$uini.inicialitzar}");
			call.executeUpdate();	
			call = conn.prepareCall(SQL_DNI);

			// Carreguem els paràmetres
			call.setString(1,login); //Anyaca
			
			// Carreguem les dades a la llista de retorn
			ResultSet rst = call.executeQuery();
			// Carreguem les dades a la llista de retorn
			
			while (rst.next()) {
				dni = rst.getString("PRS_DNIPRS");
			}
			
			rst.close();
			call.close();
		}
		catch (Exception ex){
			System.out.println("Error al transformar el login");
		}

		//Retornem la connexio
		returnConnection(conn);
		System.out.println("El dni " + dni);
		return dni;
	}
	
	public boolean desaDades(List llistalinies){
		//Obtenim la connexio
		Connection conn = getConnection(); 
		
		//Obtenim les linies de llista que s'han de modificar
		Iterator it = llistalinies.iterator();
		
		boolean errors=false;
		
		try{
			
			CallableStatement call = null;
		
			int i=1; // Contador per a reescriure els missatges. 
			
			//
			while (it.hasNext()){
				LiniaActaServ aux = (LiniaActaServ) it.next();
			
				//Preparem el procediment
				call = conn.prepareCall("{call ALU$IOLAC.PR_UPDATE(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
				
				//Inserim els parametres
				call.setString(1,aux.getPla_codalf()); 
				call.setString(2,aux.getExp_numord());
				call.setString(3,aux.getAnyaca());
				call.setString(4,"" + aux.getAss_codnum());
				call.setString(5,aux.getTco_codalf());
				call.setString(6,"" + aux.getGas_codnum());
				call.setString(7,"" +aux.getAct_numord());
				call.setString(8,aux.getQua_codalf());
				
				//Controlem de ficar la nota del tipus numerica o null (sino ficaria 0.0 i fallaria)
				if (aux.getQuanum()!= null){
					double nota = Double.valueOf(aux.getQuanum());
					call.setDouble(9,nota);
				}
				else 
					call.setString(9,null);
				
				Double provaZero = 0.0;
				call.setDouble(10,provaZero);
				call.setString(11,aux.getTqu_codalf());
				call.setString(12,aux.getPac_codnum());
				call.setString(13,aux.getPla_codalfmat());
				
			/*	System.out.println("Dades de la linia" +
				"1 " +aux.getPla_codalf() + "\n" +  
				"2 " +aux.getExp_numord() + "\n" + 
				"3 " +aux.getAnyaca() + "\n" + 
				"4 " +aux.getAss_codnum() + "\n" + 
				"5 " +aux.getTco_codalf() + "\n" + 
				"6 " +aux.getGas_codnum() + "\n" + 
				"7 " +aux.getAct_numord() + "\n" + 
				"8 " +aux.getQua_codalf() + "\n" + 
				"9 " +aux.getQuanum() + "\n" + 
				"10 " +aux.getTqu_codalf() + "\n" + 
				"11 " +aux.getPac_codnum() + "\n" + 
				"12 " +aux.getPla_codalfmat() + "\n" );*/
									
				
				try{
					//Executem i si tot va bé ho marquem com un exit
					call.executeUpdate();
					aux.setInc(false);
					aux.setMsgerror("");
				}catch (SQLException ex){
					//Si falla marquem la linia com incorrecte i especifiquem l'error
					aux.setInc(true);
					errors = true;
					//De moment extreurem només el primer missatge entre ORAS
					int index1 = ex.getMessage().indexOf(":");
					int index2 = ex.getMessage().indexOf("ORA-",index1);
					String problema;
					if (-1 < index1 && index1 < index2){
						problema = ex.getMessage().substring(index1+1,index2);
						aux.setMsgerror(i + ") " + problema);
					}
					else {
						aux.setMsgerror(i + ") " + "Hi ha un error de incompatibilitat a l'hora d'inserir aquesta linia");
					}
					i++;
				}
				
				//Tamquem la crida
				call.close();
			
			}
			
			//retronem la connexio
			returnConnection(conn);
		return !errors;// Retornme el estat del process
		
		}catch (Exception ex){
			System.out.println("No s'ha pogut desar la linia");
			return false;
		}
	}
	
	
	/*Setter dels parametres driver i db*/
	public void setDriver(String dd) {
		driver = dd;
	}

	public void setDb(String data) {
		db = data;
	}		

	
	//Obté una connexió del pool de connexions
			
	public Connection getConnection() {
		Connection conn = null;

		try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		try{
			conn =DriverManager.getConnection(db);
		}catch (SQLException ex){
			System.out.println("No s'ha pogut obtenir la connexió");
		}
		
		
		/*
		
		if (ds == null) {
			ds = setupDataSource();
			System.out.println("El ds es null");
		}
		try {
			conn = ds.getConnection();
			//System.out.println("Creem la connexio");
		} catch (SQLException ex) {
			System.out.println("Error al obtindre la connexio");
		}*/
		return conn;
	}

	//Tanca la connexió solicitada
	
	public void returnConnection(Connection conn) {
		try {
			conn.close();
		} catch (SQLException ex) {
			System.out.println("Error al tancar la connexio");
		}

	}


	// Configurem l'accés a la base de dades
	
	public DataSource setupDataSource() {

	/*	try {
			Class.forName(driver);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		
	    BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName(driver);
        //ds.setUsername("admin_user");
        //ds.setPassword("client00");
        ds.setUrl(db);
        return ds;*/
		
		/*connectionPool = new GenericObjectPool(null);
		ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(
				db, null);
		PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(
				connectionFactory, connectionPool, null, null, false, true);
		PoolingDataSource dataSource = new PoolingDataSource(connectionPool);
		
		return dataSource;
		
		*/
		
		return null;
		
	}
}



