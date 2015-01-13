

org 100h

mov ax, 0B800h          ; ce segment initialise la memoire video
mov ds, ax

mov al, 48              ; Les chiffres débutent au code ASCII 48
mov es:[12], al         ; cette initialisation permet d'afficher le score a la fin
mov es:[14], al         ; meme s'il est de 0
mov es:[16], al
mov es:[18], al         ; ces lignes represente les unites, dizaines, centaines
                        ; et milliers pour le score
                        
mov es:[22], ax         


mov ax, 5
mov es:[2], ax          ; es:[2] sert a compter les vies

mov ax, 70              ; on initialise es:[4] avec un emplacement vide
mov es:[4], ax          ; es:[4] sert a enregistrer la derniere position de bx

xor ax, ax
mov es:[22], ax         ; es:[22] compte le nombre de briques effacees
mov es:[0], ax          ; es:[0] enregistre le score


; modifier ici ax pour afficher directement un niveau, pour y jouer,
; il faut egalement modifier le "jmp deplacement_clavier" en "call raquette"
; dans le code,   ici, ax est a zero, ce qui correspond au niveau d'introduction
;mov ax, 2 

mov es:[24], ax

              
call dessin_cadre               
               

debut:

xor dx, dx
xor ax, ax

cmp es:[24], 0            ; ces comparaisons servent a savoir quel niveau dessiner
jz intro_dessin

cmp es:[24], 1
jz niveau_1

cmp es:[24], 2
jz niveau_2

cmp es:[24], 3
jz niveau_3
                                                


ret




 
 
    
    
; ______________________________________________________________________________________
;|                                                                                      |
;|                                   DESSIN CADRE                                       |
;|______________________________________________________________________________________|





dessin_cadre proc               ; procedure de dessin du cadre
    
pusha                 
                                ; on marque une a une les lettres dans les differentes
mov [00], 'S'                   ; "cases" de la fenetre
mov [02], 'c'
mov [04], 'o'
mov [06], 'r'
mov [08], 'e'
mov [12], ':'
mov [16], '0'
mov [18], '0'
mov [20], '0'
mov [22], '0'

mov [148], 'P'
mov [150], 'V'
mov [154], ':'
mov [158], '5'
 

xor ax, ax
mov bx, 320                     ; 320 correspond au debut de, la troisieme ligne
mov cx, 24
         
         
cadre_colonnes:
                                ; on dessine le symbole au debut de la ligne
mov [bx], 49h                   ; on place bx a la fin de la ligne
add bx, 158                     ; pour dessiner le suivant
mov [bx], 049h                  ; et on ajoute 2 pour arriver a la ligne suivante
add bx, 2
loop cadre_colonnes
      
      
mov cx, 80
mov bx, 160                     ; 160 correspond a la deuxieme ligne

cadre_ligne:

mov [bx], 5fh                   ; on dessine le _
add bx, 2                       ; et on ajoute deux pour passer a la case suivante

loop cadre_ligne

popa

ret

dessin_cadre endp 
    
 
 


                           ; INTRODUCTION DU JEU



intro_dessin:

mov [1986], 0c4h
mov [2310], 0c4h
mov [1994], 0c4h
mov [2318], 0c4h
mov [2002], 0c4h
mov [2326], 0c4h

mov ax, 1
mov bx, 322

call raquette              ; l'introduction appelle la fonction raquette
                           ; les prochains niveaux sautent directement dans la fonction
                           ; pour eviter de redessiner la raquette


 





; ______________________________________________________________________________________
;|                                                                                      |
;|                                    DESSIN CROIX                                      |
;|______________________________________________________________________________________|


niveau_1:

dessin_croix proc

pusha

mov ax, 160          
mov bx, 2000         ;bx est mis a 2000, le centre de la fenetre, c'est le repere
mov cx, 7            ;on se sert de cx pour decider de la longueur de la croix
mov dx, 2            ;ax et dx sont des variables ajoutees/soustraites
                     ;au repere pour tracer les fragments de croix



mov [bx], 0c5h

croix:

push bx
sub bx, ax
mov [bx], 0B3h
pop bx

push bx
add bx, ax           ; pour eviter de modifier bx sur le long terme
mov [bx], 0B3h       ; on peut :
pop bx

push bx              ; soit faire un push suivi d'un pop
sub bx, dx
mov [bx], 0c4h
pop bx

add bx, dx           ; soit utiliser l'operation inverse apres le mov : add/sub
mov [bx], 0c4h
sub bx, dx 

add ax, 160
add dx, 2

loop croix

popa

mov bx, 322
mov ax, 1

jmp deplacement_clavier


dessin_croix endp







; ______________________________________________________________________________________
;|                                                                                      |
;|                                   DESSIN NIVEAU LAPIN                                |
;|______________________________________________________________________________________|



niveau_2:

lapin proc                     ; dessin du niveau lapin

pusha

mov bx, 690
mov cx, 14

dessiner_vertical1:

mov [bx], 0b3h
add bx, 50 
mov [bx], 0b3h
add bx, 110
loop dessiner_vertical1

mov bx, 532
mov cx, 4

dessiner_boucle_horiz1:

mov [bx], 0c4h
mov [bx + 40], 0c4h
add bx, 2

loop dessiner_boucle_horiz1

mov cx, 4
mov ax, 130
mov bx, 700

dessiner_vertical2:

mov [bx], 0b3h
add bx, 30
mov [bx], 0b3h
add bx, 130
loop dessiner_vertical2:

mov cx, 14


horiz2:
add bx, 2
mov [bx], 0c4h
loop horiz2

mov bx, 2932
mov cx, 5


horiz3:

mov [bx], 0c4h
mov [bx + 38], 0c4h
mov [bx + 492], 0c4h
mov [bx + 506], 0c4h

add bx, 2

loop horiz3

mov [bx + 492], 0c4h
;mov [bx + 494], 0c4h

mov cx, 3

vertical3:

mov [bx], 0b3h
mov [bx + 14], 0b3h
add bx, 26
mov [bx], 0b3h
add bx, 134

loop vertical3

mov bx, 1827
mov cx, 2


mov [bx], 0b2h
mov [bx + 18], 0b2h
add bx, 160
mov [bx], 0b1h
mov [bx + 18], 0b1h
add bx, 160
mov [bx], 0b1h
mov [bx + 18], 0b1h

mov bx, 2457
mov [bx], 0dch
mov [bx + 2], 0dch
mov [bx + 36], 0dch
mov [bx + 38], 0dch

popa

mov bx, 322
mov ax, 1

jmp deplacement_clavier

ret

lapin endp



; ______________________________________________________________________________________
;|                                                                                      |
;|                                      DESSIN TV                                       |
;|______________________________________________________________________________________|


niveau_3:


dessin_tv proc

pusha

mov ax, 2    
mov bx, 850
mov dx, 160
mov cx, 13


telebi:

add bx, ax
mov [bx], 0c4h
mov [bx + 2240], 0c4h
mov [bx + 2], 0c4h
mov [bx + 2242], 0c4h
sub bx, ax

add bx, dx
mov [bx], 0b3h
mov [bx + 54], 0b3h
sub bx, dx

add ax, 4
add dx, 160


loop telebi

mov bx, 1176
mov [bx], 0dah
mov cx, 9
mov ax, 2
mov dx, 160

cadre_tele:

add bx, ax
mov [bx], 0c4h
mov [bx + 1600], 0c4h
mov [bx + 2], 0c4h
mov [bx + 1602], 0c4h
sub bx, ax

add bx, dx
mov [bx], 0b3h
mov [bx + 38], 0b3h
sub bx, dx

add ax, 4
add dx, 160

loop cadre_tele

mov [2178], 0b8h
mov [1858], 0b8h
mov [1538], 0b8h

popa
                     
                       
jmp deplacement_clavier

ret

dessin_tv endp





; ______________________________________________________________________________________
;|                                                                                      |
;|                                   DEPLACEMENT BALLE                                  |
;|______________________________________________________________________________________|
    
    
    
balle proc                    ;procedure de deplacement de la balle
    

mouvement_bas_droite:

xor dx, dx                    ; on remet dx a zero pour ne pas fausser la division

push bx                       ;on push bx
mov bx, es:[4]                ;on place dans bx sa valeur precedente
mov [bx], 00h                 ;et on efface la trace de la balle
pop bx                        ;on pop bx pour reprendre l'emplacement actuel de la balle

cmp bx, 3680                
ja derniere_ligne_droite      ;si on est a la derniere on envoie la balle a une fonction
                              ;qui teste si il y a une raquette
mov ax, [bx]                  ;on place dans ax le symbole a l'emplacement present
mov es:[4], bx
mov [bx], 01h                 ;avant de modifier bx, on sauvegarde sa valeur dans es:[4]

cmp al, 0c4h           ;al correspond au symbole qu'on a stocke dans ax un peu plus tot
jz  score_mouvement_haut_droite
cmp al, 0b3h           ;on le compare alors aux differents symboles composant la croix
jz score_mouvement_bas_gauche
cmp al, 0c5h           ;et on saute au mouvement qui convient si l'un d'eux est reconnu
jz score_mouvement_haut_gauche

                       ;le prefix score indique qu'on appelle d'abord une fonction score
mov ax, bx             ;qui augmente le score et le nombre de briques effacees
add ax, 4
push bx
    mov bx, 160
    div bx
pop bx
or dx, dx
jz cadre_mouvement_bas_gauche

add bx, 162

                        
jmp cadre_mouvement_bas_droite       
                                            
                   
mouvement_haut_droite:

xor dx, dx

push bx
mov bx, es:[4]
mov [bx], 00h
pop bx

mov ax, [bx]
mov es:[4], bx
mov [bx], 01h

cmp al, 0c4h
jz  score_mouvement_bas_droite
cmp al, 0b3h
jz score_mouvement_haut_gauche
cmp al, 0c5h
jz score_mouvement_bas_gauche


    saut_raquette_droite:


mov ax, bx
add ax, 4                    ;on teste si bx est a la derniere colonne avec une division
push bx                      ;on teste la modulo, en divisant par 160
    mov bx, 160              ;si le reste est de 0, bx est a la derniere colonne
    div bx
pop bx                            ; "div" divise ax par bx et place le reste dans dx
or dx, dx
jz cadre_mouvement_haut_gauche

cmp bx, 480
jb cadre_mouvement_bas_droite

sub bx, 158
jmp cadre_mouvement_haut_droite


mouvement_haut_gauche:

xor dx, dx

push bx
mov bx, es:[4]
mov [bx], 00h
pop bx

mov ax, [bx]
mov es:[4], bx
mov [bx], 01h

cmp al, 0c4h
jz  score_mouvement_bas_gauche
cmp al, 0b3h
jz score_mouvement_haut_droite
cmp al, 0c5h
jz score_mouvement_bas_droite


    saut_raquette_gauche:


mov ax, bx
sub ax, 2
push bx
    mov bx, 160
    div bx
pop bx
or dx, dx
jz cadre_mouvement_haut_droite

cmp bx, 480          ;on teste si bx est a la premiere ligne qui est entre 320 et 160
jb cadre_mouvement_bas_gauche

sub bx, 162
jmp cadre_mouvement_haut_gauche


mouvement_bas_gauche:

xor dx, dx

push bx
mov bx, es:[4]
mov [bx], 00h
pop bx

cmp bx, 3680                 
ja derniere_ligne_gauche   


mov ax, [bx]
mov es:[4], bx
mov [bx], 01h

cmp al, 0c4h
jz  score_mouvement_haut_gauche
cmp al, 0b3h
jz score_mouvement_bas_droite
cmp al, 0c5h
jz score_mouvement_haut_droite


mov ax, bx
sub ax, 2
push bx
    mov bx, 160
    div bx
pop bx
or dx, dx
jz cadre_mouvement_bas_droite


add bx, 158
;mov [bx - 158], 00h                          ancienne methode
jmp cadre_mouvement_bas_gauche

ret

balle endp


; ______________________________________________________________________________________
;|                                                                                      |
;|                                       RAQUETTE                                       |
;|______________________________________________________________________________________|




raquette proc                      ; dessin et deplacement de la raquette
    
push ax
push bx                            ; initialisation, dessin de la raquette
  
mov bx, 3840                       ; 3840 est le debut de la derniere ligne
 
mov [bx + 50], 58h                 ; on se sert de bx comme repere, on lui ajoute des 
mov [bx + 52], 58h                 ; valeurs pour dessiner des croix (58h)
mov [bx + 54], 58h                   
mov [bx + 56], 58h
mov [bx + 58], 58h
 
                                   ; es:[10] sert de sauvegarde pour la position du
mov ax, 3840                       ; repere pour la raquette, on l'initialise a 3840
mov es:[10], ax
 
pop bx
pop ax
 
 
deplacement_clavier:               ; procedure de deplacement au clavier
 
push ax
push bx

mov bx, es:[10]                    ; on place dans bx l'emplacement du repere

xor dx, dx
xor ax, ax

mov ah, 6                         ; l'option 255 de l'int 21h sert a recuperer une donnee
mov dl, 255                       ; entree au clavier, cette donnee est placee dans al
int 21h


cmp al, 113                     ; on compare ensuite al avec les codes des lettre q ou d
jz mouvement_gauche

cmp al, 100                     ; et on passe a la partie adaptee
jz mouvement_droit
 
jmp fin
 
mouvement_gauche:               ; ces fonctions effacent le dernier X et en place un  
                                ; de l'autre cote
cmp bx, 3792
jz fin
sub bx, 2
mov [bx + 60], 00h              ; 00h sert a effacer
mov [bx + 50], 58h
jmp fin
 
mouvement_droit:

cmp bx, 3938
jz fin 
add bx, 2
mov [bx + 48], 00h
mov [bx + 58], 58h
 
fin:
 
mov es:[10], bx

pop bx
pop ax


cmp ax, 1
jz mouvement_haut_droite        ;on se sert de ax, modifie pendant les transitions
                                ;pour continuer avec le bon mouvement
cmp ax, 2
jz mouvement_bas_droite

cmp ax, 3
jz mouvement_haut_gauche

cmp ax, 4
jz mouvement_bas_gauche
 
ret
   
raquette endp 

    
    
    
    
    
    
; ______________________________________________________________________________________
;|                                                                                      |
;|                                        SCORE                                         |
;|______________________________________________________________________________________|


score proc
    
push ax
push bx
push dx

inc es:[22]                 ; es:[22] sert a compter les briques detruites
add es:[0], 5               ; es:[0] compte le score, on l'augmente par 5


mov ax, es:[0]              ; on place le score total dans ax pour le diviser
xor dx,dx                   ; on remet dx a zero
mov bx,1000                 ; on va diviser par 1000

div bx

add al, 48                  ; on veut afficher le quotient, c'est a dire al
mov es:[12], al             ; on place le nombre des milliers dans es:[12]
mov [16], al                ; et on l'affiche


mov ax, dx                  ; on place le reste dans ax
xor dx, dx
mov bx, 100                 ; et on divise cette fois par 100
div bx

add al, 48
mov es:[14], al
mov [18], al


mov ax,dx                   ; on repete la procedure pour les dizaines
mov dx, 0                   
mov bx, 10

div bx

add al, 48
mov es:[16], al
mov [20], al


add dl, 48                  ; pour les unites, il suffit d'afficher al 
mov es:[18], dl
mov [22], dl
  
  
mov bx, es:[22]
mov [2000], bx  
mov ax, es:[22]             ; quand es:[22] atteint un nombre particulier
cmp ax, 6                   ; on change de niveau                                                  
jz niveau_suivant

mov ax, es:[22]
cmp ax, 35
jz niveau_suivant


mov ax, es:[22]
cmp ax, 123
jz niveau_suivant



pop dx
pop bx
pop ax



jmp deplacement_clavier


score endp



                                                                                        
                                                                                         
                                                                                         
; ______________________________________________________________________________________
;|                                                                                      |
;|                                     TRANSITIONS                                      |
;|______________________________________________________________________________________|




cadre_mouvement_haut_droite:         ; ces transitions servent a
                                     ; marquer la direction de la balle
mov ax, 1                            ; pour pouvoir reprendre le bon mouvement
jmp deplacement_clavier              ; apres la fonction "score" (prefixe "score") ou
                                     ; celle du deplacement de la croix (prefixe "cadre")

cadre_mouvement_bas_droite:

mov ax, 2
jmp deplacement_clavier               


cadre_mouvement_haut_gauche:

mov ax, 3
jmp deplacement_clavier


cadre_mouvement_bas_gauche:

mov ax, 4
jmp deplacement_clavier




score_mouvement_haut_droite:

mov ax, 1
jmp score

score_mouvement_bas_droite:

mov ax, 2
jmp score

score_mouvement_haut_gauche:

mov ax, 3
jmp score

score_mouvement_bas_gauche:

mov ax, 4
jmp score




niveau_suivant:

inc es:[24]
jmp debut




                                                                                         
; ______________________________________________________________________________________
;|                                                                                      |
;|                                   DERNIERE LIGNE                                     |
;|______________________________________________________________________________________|






derniere_ligne_droite:

mov [bx], 001h
mov es:[4], bx
cmp [bx + 160], 58h
jz saut_raquette_droite

cmp [bx + 162], 58h                   ; si la balle tape dans le coin de la raquette
jz saut_raquette_gauche               ; elle est renvoyee dans le sens inverse.


mov [bx], 00h
add bx, 162
mov es:[4], bx
mov [bx], 001h
call point_de_vie    
    

derniere_ligne_gauche:

mov [bx], 001h
mov es:[4], bx
cmp [bx + 160], 58h
jz saut_raquette_gauche

cmp [bx + 158], 58h                  
jz saut_raquette_droite


mov [bx], 00h
add bx, 158
mov es:[4], bx
mov [bx], 001h
call point_de_vie




; ______________________________________________________________________________________
;|                                                                                      |
;|                               POINTS DE VIE   /   PERDU                              |
;|______________________________________________________________________________________|



point_de_vie proc              ;cette procedure est appelee si la balle touche
                               ;la derniere ligne et qu'il n'y a pas de raquette
pusha 
 
dec es:[2]                     ;on decremente es:[2] qui contient le nombre de vies
mov ax, es:[2]                 ;et on le place dans ax/al pour connaitre sa valeur

add al, 48                     ;de facons a l'afficher avec al, si on augmente al
mov [158], al                  ;c'est parce qu'en ascii les chiffres commencent a 48

popa

mov [bx + 162], 00h

jmp test_perdu 


point_de_vie endp



perdu proc                      ; procedure quand points de vie = 0   

    
test_perdu:

mov bx, 322                     ; on replace bx a 322 pourla partie suivante
cmp es:[2], 0                   ; on teste s'il reste des vies
jnz mouvement_bas_droite        ; si oui, on retourne au debut

    
    
mov bx, 1628
mov [bx + 320], 0bah
mov [bx + 160], 0bah
mov [bx], 0c9h
mov cx, 50

ecrire_perdu_1:

add bx, 2
mov [bx], 0cdh

loop ecrire_perdu_1

mov [bx], 0bbh
mov [bx + 160], 0bah
mov [bx + 320], 0bah
mov [bx + 480], 0bch

add bx, 480
mov cx, 50

ecrire_perdu_2:

sub bx, 2
mov [bx], 0cdh

loop ecrire_perdu_2

mov [bx], 0c8h


mov ax, es:[12]
mov [2010], al
mov ax, es:[14]
mov [2012], al             
mov ax, es:[16]
mov [2014], al
mov ax, es:[18]
mov [2016], al


                              ;ces lignes indiquent la position du message appele
mov dh, 11                    ;lignes/colonnes
mov dl, 24
mov bh, 0                     ;ah sert a designer la fonction de l'interruption 21h
mov ah, 2
int 10h
                              
mov ax, seg msg_perdu_1         ;on nomme le segment contenant de message
mov ds, ax
mov dx, offset msg_perdu_1
mov ah, 9                     ;on place dans ah la fonction a utiliser
int 21h

popa



MOV DH, 12
MOV DL, 24
MOV BH, 0
MOV AH, 2
int 10h

MOV AX, SEG msg_perdu_2
MOV DS, AX
MOV DX, OFFSET msg_perdu_2
MOV AH, 9
int 21h



perdu endp

msg_perdu_1 db "     Tu as perdu !    >.<         $"
msg_perdu_2 db "     Ton score :      $"