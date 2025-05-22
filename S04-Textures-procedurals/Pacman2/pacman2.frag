#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colorMap;

const float n = 15;
const float sprite_size = 6.0;

const float GHOST  = 0.0 / sprite_size;
const float PACMAN = 1.0 / sprite_size;
const float EMPTY  = 2.0 / sprite_size;
const float WALL   = 3.0 / sprite_size;
const float CORNER = 4.0 / sprite_size;
const float DOT    = 5.0 / sprite_size;

void main() { //Could be better but it works

    float gridX = vtexCoord.x * n;
    float gridY = vtexCoord.y * n;
    int cellX = int(gridX);
    int cellY = int(gridY);
    
    vec2 localCoord = vec2(fract(gridX), fract(gridY));
   
    // Background
    float offsetX = EMPTY;
    ///////////////////FRAME/////////////////////////////////////////////////////////////////////////////
    // Horizontal Walls
    if (cellX > 0 && cellX < int(n-1) && (cellY == 0 || cellY == int(n-1))) 
        offsetX = WALL;
   
    // Vertical Walls
    else if ((cellX == 0 || cellX == int(n - 1)) && cellY > 0 && cellY < int(n-1)) {
        localCoord = vec2(localCoord.y, localCoord.x);//Rotate
        offsetX = WALL;
    }
    //(1) Top-right (no rotation)
    else if (cellX == int(n-1) && cellY == int(n-1)) 
    	offsetX = CORNER;
    //(2) Bottom-right (-90 degrees rotation)
    else if (cellX == int(n-1) && cellY == 0) {
		localCoord = vec2(1.0 - localCoord.y, localCoord.x);//Rotate
		offsetX = CORNER;		    
    }//(3) Bottom-left (-180 degrees rotation)
    else if (cellX == 0 && cellY == 0) {
		localCoord = vec2(1.0 - localCoord.y, 1.0 - localCoord.x);//Rotate
		offsetX = CORNER;		    
    }//(4) Top-left (-270 degrees rotation)
    else if (cellX == 0 && cellY == int(n-1)) {
		localCoord = vec2(localCoord.y, 1.0 - localCoord.x);//Rotate
		offsetX = CORNER;		    
    }
	////////////////////////////////////////////////////////////////////////////////////////////////////
    else if (cellX == int(n/2)-1 && cellY == int(n/2)-1) {
    	localCoord = vec2(1.0 - localCoord.y, localCoord.x);//Rotate
        offsetX = PACMAN;
	}
    else if ((cellX == int(n/2)+2 && cellY == int(n/2)) || (cellX == int(n/2)-1 && cellY == int(n/2)-3)) 
        offsetX = GHOST;

    else if ((cellX == int(n/2)-1 && cellY == int(n/2)+1)|| (cellX == int(n/2)-1 && cellY == int(n/2)+2) || 
    		(cellX == int(n/2) && cellY == int(n/2)+2) || (cellX == int(n/2) && cellY == int(n/2)+4) ||
    		(cellX == int(n/2)-3 && cellY == int(n/2)+3) || (cellX == int(n/2)+5 && cellY == int(n/2)+2) ||
    		(cellX == int(n/2)-4 && cellY == int(n/2)-5) || (cellX == int(n/2)+6 && cellY == int(n/2)-5) ||
    		(cellX == int(n/2)-3 && cellY == int(n/2)+3) || (cellX == int(n/2)-3 && cellY == int(n/2)+3) ||
    		cellY > int(n/2) + 5)
        offsetX = DOT;
   	else if (((cellY <= int(n/2)+1) && mod(cellY,2) != 0) || cellY == int(n/2) + 4) {
       	if (cellX != int(n/2) && cellY != int(n/2)-2 && cellX != int(n/2) - 3)
       		offsetX = WALL; //Horizonal wall
       	else if ((mod(cellX, 5) <= 2) && cellX != int(n/2) && cellX != int(n/2)-1) {
			localCoord = vec2(localCoord.y, localCoord.x);//Rotate
       	 	offsetX = WALL; //Vertical wall
       	}
    }
    vec2 board = vec2(offsetX + localCoord.x / sprite_size, localCoord.y);

    fragColor = texture(colorMap, board);
}

