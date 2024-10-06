/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package basesdedatos2;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 *
 * @author Julian
 */
public class Taller11 {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres","postgres","juli2005");
            
            CallableStatement ejecucion1 = conexion.prepareCall("{ call taller9.obtener_nomina_empleado(?,?,?) }");
            ejecucion1.setString(1, "1");
            ejecucion1.setInt(2, 4);
            ejecucion1.setInt(3, 2024);
            
            ResultSet res = ejecucion1.executeQuery();
   
            while(res.next()){
            System.out.println("Nombre " + res.getString("nombre"));
            System.out.println("Total Devengado " + res.getString("total_devengado"));
            System.out.println("Total Deducciones " + res.getString("total_deducciones"));
            System.out.println("Total " + res.getString("total"));
            } 
            ejecucion1.close();
            
            
            CallableStatement ejecucion2 = conexion.prepareCall("{ call taller9.total_por_contrato(?) }");
            ejecucion2.setString(1, "2");
            ResultSet res2 = ejecucion2.executeQuery();
            
            while(res.next()){
                System.out.println("Nombre " + res2.getString("nombre"));
                System.out.println("Fecha pago " + res.getString("fecha_pago"));
                System.out.println("Año " + res2.getString("año"));
                System.out.println("Mes " + res2.getString("mes"));
                System.out.println("Total Devengado " + res2.getString("total_devengado"));
                System.out.println("Total Deducciones " + res2.getString("total_deducciones"));
                System.out.println("Total " + res2.getString("total"));
            }
            ejecucion2.close();
       }
        catch(Exception e){
            System.out.println(e.getMessage());
        }
    }
}
