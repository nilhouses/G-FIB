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
        if (gTexCoord.x > 2 && gTexCoord.x < 3 && gTexCoord.y > 1 && gTexCoord.y < 6)
            fragColor = BLACK;
        else if (gTexCoord.x > 3 && gTexCoord.x < 4 && gTexCoord.y > 3 && gTexCoord.y < 4)
            fragColor = BLACK;
        else if (gTexCoord.x > 3 && gTexCoord.x < 5 && gTexCoord.y > 5 && gTexCoord.y < 6)
            fragColor = BLACK;
        else
            fragColor = YELLOW;
    }
    else //The rest of the image
        fragColor = gfrontColor;
}
