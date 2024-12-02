/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.mongodbmaven;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Session;
import org.neo4j.driver.SessionConfig;
import static org.neo4j.driver.Values.parameters;

/**
 *
 * @author Julian
 */
public class PersonaService {
    private static final Driver driver = Neo4J.getDriver();
    private Session session;
    
    public PersonaService(){
        session = driver.session(SessionConfig.forDatabase("neo4j"));
    }
    
    public void crearPersona (String identificacion, String nombre, int edad, String correo, String ciudad){
        String cypherQuery = "CREATE (p:Persona {identificacion: $identificacion,nombre: $nombre,edad: $edad, correo: $correo, ciudad: $ciudad})";
        session.run(cypherQuery, parameters("identificacion",identificacion,"nombre",nombre,"edad",edad,"correo",correo, "ciudad", ciudad));
        System.out.println("Persona creada: " + nombre);
    }
    
    
}
