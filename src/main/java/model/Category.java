package model;
import java.io.Serializable;
public class Category implements Serializable {
    private int id; private String name; private boolean deleted;
    public Category(int id,String name){this.id=id;this.name=name;}
    public int getId(){return id;} public String getName(){return name;} public void setName(String v){name=v;}
    public boolean isDeleted(){return deleted;} public void setDeleted(boolean v){deleted=v;}
}
