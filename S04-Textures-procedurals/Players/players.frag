#version 330 core

in vec2 vtexCoord;
in vec2 P; //Court space[-5,-10], [5,1]
 
out vec4 fragColor;

uniform sampler2D courtMap;
uniform sampler2D player1; 
uniform int mode = 3;

//Players
uniform vec2 p1 = vec2(-3,-8);
uniform vec2 p2 = vec2(3,-8);
uniform vec2 p3 = vec2(-2,2);
uniform vec2 p4 = vec2(2,2);

void main() 
{
	vec4 color = vec4(0);
    if (mode == 0) color = texture(courtMap,vtexCoord);
    else {
    	color = texture(courtMap,vtexCoord);
    	//mode 1 
    	if ((fract(P.x) >= 0.0 && fract(P.x) < 0.05) ||
    		(fract(P.y) >= 0.0 && fract(P.y) < 0.05)) 
    		color = vec4(vec3(color.xyz)*1.2,color.w);
    	
    	if (mode == 2) {//Circle

		    if (distance(P, p1) <= 0.5 || 
		    	distance(P, p2) <= 0.5 ||
		    	distance(P, p3) <= 0.5 ||
		    	distance(P, p4) <= 0.5) color = vec4(vec3(0.0), 1.0); //Black
		    		
		    if (distance(P, p1) <= 0.4 ||
		    	distance(P, p2) <= 0.4 ||
		    	distance(P, p3) <= 0.4 ||
		    	distance(P, p4) <= 0.4) color = vec4(1.0); //White
    	}else if (mode == 3) {//Players
    	
			if (abs((p1-P).x) <= 1.0 && abs((p1-P).y) <= 1.0) {
			    vec2 st = ((p1-P) + vec2(1.0, 1.0))* 0.5;
			    vec2 rot = vec2(1.0) - st;
			    vec4 col = texture(player1, rot);
				if (col.x > 0.5 || col.z < 0.5)
			    	color = col;
			}
			if (abs((p2-P).x) <= 1.0 && abs((p2-P).y) <= 1.0) {
			    vec2 st = ((p2-P) + vec2(1.0, 1.0))* 0.5;
			    vec2 rot = vec2(1.0) - st;
			    vec4 col = texture(player1, rot);
				if (col.x > 0.5 || col.z < 0.5)
			    	color = col;
			}
			if (abs((p3-P).x) <= 1.0 && abs((p3-P).y) <= 1.0) {
			    vec2 st = ((p3-P) + vec2(1.0, 1.0))* 0.5;
			    vec4 col = texture(player1, st);
				if (col.x > 0.5 || col.z < 0.5)
			    	color = col;
			}
			if (abs((p4-P).x) <= 1.0 && abs((p4-P).y) <= 1.0) {
			    vec2 st = ((p4-P) + vec2(1.0, 1.0))* 0.5;
			    vec4 col = texture(player1, st);
				if (col.x > 0.5 || col.z < 0.5)
			    	color = col;
			}
			
    	}
    }
    fragColor = color;
}
