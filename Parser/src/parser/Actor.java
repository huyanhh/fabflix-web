
package parser;

import java.util.Date;
import java.util.Objects;

/**
 *
 * @author krish
 */
public class Actor {
    //bad coding should use getters but I don't care
    public Integer id;
    public String stageName;
    public String firstName;
    public String lastName;
    public Date dob;

    Actor(String stage, String last, String first,Date dateOfBirth ) {
        stageName = stage;
        lastName = last;
        firstName = first;
        dob = dateOfBirth;
    }
    
    @Override
    //compare by value not by reference for relation
    public boolean equals(Object o)
    {
        Actor rhs = (Actor) o;
        return stageName.equals(rhs.stageName);
    }

    @Override
    //compare by value not by reference for relation
    public int hashCode() {
        int hash = 7;
        hash = 11 * hash + Objects.hashCode(this.stageName);
        return hash;
    }
    
    @Override
    public String toString(){
        return "stageName: " + stageName + ", lastName: " + lastName + ", firstName: " + firstName + ", dateOfBirth: " + dob + "\n";
    }
}
