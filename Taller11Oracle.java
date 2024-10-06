/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package basesdedatos2;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Julian
 */
public class Taller11Oracle {
    public static void main(String[] args) {
          try {
            // Cargar el controlador Oracle JDBC
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XEDPB1","system","juli2005");
            
            CallableStatement ejecucion1 = conexion.prepareCall("call taller5.generar_auditoria(?,?)");
            ejecucion1.setDate(1,new Date(2024-9-01));
            ejecucion1.setDate(2,new Date(2024-12-01));
            ejecucion1.execute();
            ejecucion1.close();
            
            CallableStatement ejecucion2 = conexion.prepareCall("call taller5.simular_ventas_mes()");
            ejecucion2.execute();
            ejecucion2.close();
            
            CallableStatement ejecucion3 = conexion.prepareCall("{ call taller9.obtener_nomina_empleado(?,?,?) }");
            ejecucion3.setString(1, "1");
            ejecucion3.setInt(2, 4);
            ejecucion3.setInt(3, 2024);
            
            ResultSet res = ejecucion3.executeQuery();
   
            while(res.next()){
            System.out.println("Nombre " + res.getString("nombre"));
            System.out.println("Total Devengado " + res.getString("total_devengado"));
            System.out.println("Total Deducciones " + res.getString("total_deducciones"));
            System.out.println("Total " + res.getString("total"));
            } 
            ejecucion1.close();
            
            
            CallableStatement ejecucion4 = conexion.prepareCall("{ call taller9.total_por_contrato(?) }");
            ejecucion4.setString(1, "2");
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

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
