/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.mongodbmaven;

/**
 *
 * @author Julian
 */
public class Persona {
    private String identificacion;
    private String nombre;
    private String correo;
    private int edad;
    private String ciudad;
    
    public Persona(String identificacion, String nombre, int edad, String correo, String ciudad){
        this.identificacion = identificacion;
        this.nombre = nombre;
        this.edad = edad;
        this.correo = correo;
        this.ciudad = ciudad;
    }

    /**
     * @return the id
     */
    public String getId() {
        return getIdentificacion();
    }

    /**
     * @param id the id to set
     */
    public void setId(String identificacion) {
        this.setIdentificacion(identificacion);
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the edad
     */
    public int getEdad() {
        return edad;
    }

    /**
     * @param edad the edad to set
     */
    public void setEdad(int edad) {
        this.edad = edad;
    }

    /**
     * @return the identificacion
     */
    public String getIdentificacion() {
        return identificacion;
    }

    /**
     * @param identificacion the identificacion to set
     */
    public void setIdentificacion(String identificacion) {
        this.identificacion = identificacion;
    }

    /**
     * @return the correo
     */
    public String getCorreo() {
        return correo;
    }

    /**
     * @param correo the correo to set
     */
    public void setCorreo(String correo) {
        this.correo = correo;
    }

    /**
     * @return the ciudad
     */
    public String getCiudad() {
        return ciudad;
    }

    /**
     * @param ciudad the ciudad to set
     */
    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }
    
    
}
