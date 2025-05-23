#version 330 core

in vec4 gfrontColor;
in vec2 gTexCoord;
out vec4 fragColor;

const vec4 WHITE = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 YELLOW = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 BLACK = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    if (gfrontColor == WHITE) //Label
    {   
        //Textura procedural
        if (gTexCoord.x < 0.5 && gTexCoord.y < 0.5) //Top left
            fragColor = YELLOW;
        else if (gTexCoord.x > 0.5 && gTexCoord.y < 0.5) //Top right
            fragColor = BLACK;
        else if (gTexCoord.x < 0.5 && gTexCoord.y > 0.5) //Bottom left
            fragColor = BLACK;
        else if (gTexCoord.x > 0.5 && gTexCoord.y > 0.5) //Bottom right
            fragColor = YELLOW;
    }
    else //The rest of the image
        fragColor = gfrontColor;
}
