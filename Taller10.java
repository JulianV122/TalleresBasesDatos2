/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package basesdedatos2;

import java.math.BigDecimal;
import java.sql.*;


/**
 *
 * @author Julian
 */
public class Taller10 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","juli2005");
            
            CallableStatement ejecucion1 = conexion.prepareCall("call taller5.generar_auditoria(?,?)");
            ejecucion1.setDate(1,new Date(2024-9-01));
            ejecucion1.setDate(2,new Date(2024-12-01));
            ejecucion1.execute();
            ejecucion1.close();
            
            CallableStatement ejecucion2 = conexion.prepareCall("call taller5.simular_ventas_mes()");
            ejecucion2.execute();
            ejecucion2.close();
            
            CallableStatement ejecucion3 = conexion.prepareCall("{ call taller6.servicios_no_pagados_mes(?) }");
            ejecucion3.setInt(1, 4);
            ResultSet res = ejecucion3.executeQuery();
            BigDecimal monto_total = new BigDecimal(0);
            while(res.next()){
                monto_total =res.getBigDecimal(1);
            }
            System.out.println(monto_total.doubleValue());
            ejecucion3.close();
            
            CallableStatement ejecucion4 = conexion.prepareCall("{ call taller6.total_mes(?,?) }");
            ejecucion4.setInt(1,4);
            ejecucion4.setString(2,"2");
            ResultSet resultado = ejecucion4.executeQuery();
            BigDecimal suma_total = new BigDecimal(0);
            while(resultado.next()){
                suma_total = resultado.getBigDecimal(1);
            }
            System.out.println(suma_total.doubleValue());
            ejecucion4.close();
            
            conexion.close();
        }
        catch(Exception e){
            System.out.println(e.getMessage());
        }
        
    }
    
}
