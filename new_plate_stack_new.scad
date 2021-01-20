use <includes/Tslot.scad>
use <MCAD/nuts_and_bolts.scad>




total_width=110;
total_length=145;
$fn=20;
plate_x = 127.71;
plate_y= 85.43;
plate_tolerance=0.1;
plate_z=30;

bottom_thickness=1;

top_of_neg_plate=10;
plate_top_extra = 10;


riser_width=3;
riser_height=50;
screw_big_hole = 6;
screw_small_hole= 2.5;

number_of_units = 3;

holder_height=7;

plate_x_offset=3;

module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}

module quadcopy()
{
    copy_mirror([1,0,0]) copy_mirror() children();
}



module neg_plate(){
    hull(){
    cube([plate_x/2+plate_tolerance, plate_y/2+plate_tolerance,0.1]);
    
    translate([0,0,top_of_neg_plate])
    cube([plate_x/2+plate_tolerance+plate_top_extra, plate_y/2+plate_tolerance+plate_top_extra,0.1]);
    }
}



module screwholething(){
    union()
    {cylinder(r=screw_small_hole,h=20,center=true);
        hull(){
            translate([0,0,-2])
            cylinder(r=screw_big_hole,h=0.0001,center=true);
        cylinder(r=screw_big_hole+2,h=0.001,center=true);
            
        }
    };
}
    
module riser(){
    
   
    difference(){
        
    cube([total_length/2,riser_width,riser_height]);
        
        translate([63-20,0,riser_height/2])
        rotate(90,[1,0,0])
        
        #screwholething();
        
    
    
    
        translate([63,0,riser_height/2])
        rotate(90,[1,0,0])
        
        #screwholething();
        
    
    }
};



module corner(){
    
   /* hull(){
translate([total_length/2- 5,total_width/2-riser_width,3])
cube([5,riser_width,18]);
translate([0,total_width/2-riser_width,riser_height-3])
cube([5,riser_width,3]);
    }*/
    
    
   quadcopy()
translate([0,total_width/2-riser_width])
riser();    

difference(){
quadcopy(){
cube([total_length/2,total_width/2,holder_height]);
}

translate([plate_x_offset,0,0])
quadcopy(){
    translate([0,0,bottom_thickness])
neg_plate();
    holder_neg();
}
}
}




module unit(){
     translate([-total_length/2,-total_width/2])
    cube([riser_width,total_width,riser_height]);
    
gap=30;
difference(){
corner();
translate([-50,-gap]) cube([200,gap*2,50]);
};
};





module  holed_unit(){
    copy_mirror(){
    translate([-70,-55])
    cube([3,16,16]);
         translate([-70,-55])
    cube([10,6,16]);
        
    translate([-70,-55,35])
    cube([10,6,15]);
         translate([-70,-55,35])
    cube([3,16,15]);
        
    }
    
    
    difference(){
     unit();
        
        quadcopy()
        hull(){ 
        
        #cube([18,49.5,10]);
       translate([30,-20,0])
        cube([18,50,10]);
         
       
        
         
     }
     
     
     
     hull(){ 
         
         translate([-35,100,40]) rotate([90,0,0]) cylinder(r=3,h=500);
        
        translate([20,100,38]) rotate([90,0,0]) cylinder(r=9,h=500);
         translate([50,100,45]) rotate([90,0,0]) cylinder(r=0.1,h=500);
       
        
         
     }
     
     hull(){ 
        
        translate([-22,100,17]) rotate([90,0,0]) cylinder(r=10,h=500);
         translate([50,100,10]) rotate([90,0,0]) cylinder(r=0.1,h=500);
       
        
         
     }
      translate([-150,25,25]) rotate([0,90,0]) cylinder(r=18,h=500);
       translate([-150,-25,25]) rotate([0,90,0]) cylinder(r=18,h=500);
    
    }
}

support_thickness_y=10;
support_thickness_z=holder_height;
holder_extra=3;
holder_negative_padding=5;

module holder(){
difference(){
    union(){
  
    
        cube([support_thickness_y,plate_y/2+plate_tolerance + holder_extra,support_thickness_z]);
    
        cube([plate_x/2+plate_tolerance + holder_extra,support_thickness_y,support_thickness_z]);
    }
    translate([0,0,1]) neg_plate();
};
}
module holder_neg(){
difference(){
    union(){
  
    
        cube([support_thickness_y+holder_negative_padding,plate_y/2+plate_tolerance + holder_extra+holder_negative_padding,20]);
    
        cube([plate_x/2+plate_tolerance + holder_extra+holder_negative_padding,support_thickness_y+holder_negative_padding,20]);
    }
 
};
}


module for_door(){

//translate([plate_x_offset,0,0]) quadcopy() color("red") holder();
difference(){
for(x=[0:riser_height:riser_height*number_of_units-1]){
    translate([0,0,x]){
        unit();
    }
}
translate([0,0,30])
#cube([300,70,40],center=true);
}

};


module not_for_door(){

//translate([plate_x_offset,0,0]) quadcopy() color("red") holder();

for(x=[0:riser_height:riser_height*number_of_units-1]){
    translate([0,0,x]){
        holed_unit();
    }
}

};

not_for_door();