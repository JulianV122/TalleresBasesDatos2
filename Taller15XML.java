/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package basesdedatos2;

/**
 *
 * @author Julian
 */

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;

public class Taller15XML {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "juli2005");
            
            CallableStatement ejecucion1 = conexion.prepareCall("call taller15xml.guardar_libro(?, ?::xml)");
            ejecucion1.setString(1, "1");
            ejecucion1.setString(2, "<libro><titulo>Harry Potter</titulo><autor>Pablo</autor><anio>1900</anio></libro>");
            ejecucion1.execute();
            ejecucion1.close();
            
            CallableStatement ejecucion2 = conexion.prepareCall("call taller15xml.actualizar_libro(?, ?::xml)");
            ejecucion2.setString(1,"1");
            ejecucion2.setString(2,"<libro><titulo>Harry Potter</titulo><autor>Pablo</autor><anio>1999</anio></libro>");
            ejecucion2.execute();
            ejecucion2.close();
            
            
            CallableStatement ejecucion3 = conexion.prepareCall("{call taller15xml.obtener_autor_libro_por_isbn(?)}");
            ejecucion3.setString(1, "1");
            ResultSet res3 = ejecucion3.executeQuery();
            
            while(res3.next()){
                System.out.println("Autor: " + res3.getString(1));
            }
            ejecucion3.close();
               
            
            CallableStatement ejecucion4 = conexion.prepareCall("{call taller15xml.obtener_autor_libro_por_titulo(?)}");
            ejecucion4.setString(1, "Harry Potter");
            ResultSet res4 = ejecucion4.executeQuery();
            
            while(res4.next()){
                System.out.println("Autor: " + res4.getString(1));
            }
            ejecucion4.close();
            
            
            CallableStatement ejecucion5 = conexion.prepareCall("{call taller15xml.obtener_libros_por_anio(?)}");
            ejecucion5.setInt(1, 1999);
            ResultSet res5 = ejecucion5.executeQuery();
            
            while(res5.next()){
                System.out.println("Titulo: " + res5.getString("titulo"));
                System.out.println("Autor: " + res5.getString("autor"));
                System.out.println("Anio: " + res5.getString("anio"));
            }
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}

