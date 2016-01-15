# -*- coding: utf-8 -*-
# -*-coding:Latin-1 -*

import Tkinter as tk
from Tkinter import *
from math import *
from PIL import Image, ImageTk
import sys
#import tkMessageBox
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg




###################### globale ###############################

racine = tk.Tk()

racine.geometry("1310x780")
racine.title("Interface_preImage")
upframe=tk.Frame(racine, padx=5)
upframe.grid(row=0,column=0, sticky = tk.S)


######################"PARAMETRES"###########################

parametre=tk.LabelFrame(upframe,text="Les parametrès de la droite : ", width=5, fg='blue')
parametre.grid(row = 0, column = 0, sticky = tk.W, ipady = 10, ipadx = 3)

######################  "quitter"  ############################
def quitcallback():
     racine.quit()
     racine.destroy()
     print"exit\n"
     return
     


bouton =tk.Button(parametre, text=' quitter !! ', command=quitcallback, bg='pink', fg='blue', height=3,width=16)   
bouton.grid(row = 1, column = 20, sticky = tk.S)


########################"taille de la fenetre"############
        
texte0 =tk.Label(parametre, text='taille de fenetre=', fg = 'black')
texte0.grid(row = 1, column = 4, sticky = tk.W)
input0 =tk.Entry(parametre, fg='black', bg='white', width=5)
input0.grid(row = 1, column = 5, sticky = tk.W+tk.E, ipadx = 6, ipady = 6)
input0.insert(0, 6)


#######################"boutton_radio"#######################

def option_equation():
    print("par une équation")
    bouton1 =tk.Button(parametre, text='Executer', command=callback1, bg='green',fg='white',height=1,width=7) 
    bouton1.grid(row = 1, column = 11, sticky = tk.W) 
    bouton2 =tk.Button(parametre, text='Executer', command=callback2,height=1,width=7,state=DISABLED) 
    bouton2.grid(row = 2, column = 11, sticky = tk.W)
    return 

def option_code():
    print("par un code")
    bouton2 =tk.Button(parametre, text='Executer', command=callback2, bg='red', fg='white',height=1,width=7) 
    bouton2.grid(row = 2, column = 11, sticky = tk.W)
    bouton1 =tk.Button(parametre, text='Executer', command=callback1,height=1,width=7,state=DISABLED) 
    bouton1.grid(row = 1, column = 11, sticky = tk.W) 

    #input0 =tk.Entry(parametre, state=DISABLED)
    #input1 =tk.Entry(parametre, state=DISABLED)
    #input2 =tk.Entry(parametre,state=DISABLED)

    return 

choix=StringVar(racine)
v = IntVar()

lab=Label(parametre, text="""Options:""",justify = LEFT,padx = 20)
lab.grid(row = 0, column = 9, sticky = tk.W)
     
rb1=Radiobutton(parametre, text="Equation",command=option_equation, padx = 20,variable=v,value=0)
rb1.grid(row = 1, column = 9, sticky = tk.W+tk.E)

rb1=Radiobutton(parametre, text="     Code",command=option_code, padx = 20,variable=v,value=1)
rb1.grid(row = 2, column = 9, sticky = tk.W+tk.E)

                 

########################"Alpha"###########################
      
texte1=tk.Label(parametre, text='           Alpha=', fg = 'black')
texte1.grid(row = 1, column = 0, sticky = tk.W)
input1 =tk.Entry(parametre, fg='black', bg='white', width=5)
input1.grid(row = 1, column = 1, sticky = tk.W+tk.E, ipadx = 5, ipady = 6)
input1.insert(0, 4/7)
########################"beta"#############################

texte2 =tk.Label(parametre, text='Beta=', fg = 'black')    
texte2.grid(row = 1, column = 2, sticky = tk.E    )
input2 =tk.Entry(parametre, fg='black', bg='white')    
input2.grid(row = 1, column = 3, sticky = tk.W+tk.E, ipadx = 5, ipady = 6)    
input2.insert(0, "ln(2)")    
########################"code de faraey"#####################

texte3 =tk.Label(parametre, text='Code de Fr=', fg = 'black')    
texte3.grid(row = 2, column = 0, sticky = tk.E    )
input3 =tk.Entry(parametre, fg='black', bg='white')    
input3.grid(row = 2, column = 1, sticky = tk.W+tk.E, ipadx = 6, ipady = 6)    
input3.insert(0,"0 1 1 0")   


######################"affichage_F1_F2"###########################

affichage=tk.LabelFrame(upframe,text="Affichage: ", width=5, fg='blue')
affichage.grid(row = 1, column = 0, sticky = tk.W, ipady = 10, ipadx = 3) 


########################"Label estNonvide_1"#####################

#text1=callback1()
#texte4 =tk.Label(parametre, text='  text1', fg = 'black')    
#texte4.grid(row = 1, column = 4, sticky = tk.E    )
#output4 =tk.Label(parametre, fg='black', bg='white', text='resultat')    
#output4.grid(row = 1, column = 5, sticky = tk.W+tk.E, ipadx = 5, ipady = 4)    

########################"Label estNonvide_2"######################

#text1=callback2()
#texte4 =tk.Label(parametre, text=' text2', fg = 'black')    
#texte4.grid(row = 2, column = 4, sticky = tk.E    )
#output4 =tk.Label(parametre, fg='black', bg='white', text='resultat')    
#output4.grid(row = 2, column = 5, sticky = tk.W+tk.E, ipadx = 5, ipady = 4)  



#######################  "run_1"  #####################################

def callback1():

     fig1.clf()      # actualiser les figures 
     fig2.clf()

     global p
     tol_txt=input0.get()
     tol_val=sage_eval(tol_txt)
     alpha_txt=input1.get()
     alphaa=sage_eval(alpha_txt)
     beta_txt=input2.get()
     betaa=sage_eval(beta_txt)   
  
     p=PreImage(alpha=alphaa, beta=betaa, tol=tol_val)   # constuction de l'objet PreImage
     p.equation_to_code()                                #afficher le motif
     p.affichage()
     canvas1.show()                                       #afficher la preImage
     canvas2.show()
     return 

									 
###################### "run_2"  ###################################

def callback2():

     fig1.clf()      # actualiser les figures 
     fig2.clf()


     
     global p
     tol_txt=input0.get()
     tol_val=sage_eval(tol_txt)     
     code_txt=input3.get()
     p=PreImage(code=code_txt)         # constuction de l'objet PreImage
     p.code_to_affichage()             #afficher le motif
     p.affichage()                     #afficher la preImage
     canvas1.show()                    #afficher la preImage
     canvas2.show()

     return 


########################### fig1   #################

fig1 = plt.figure(1,figsize=(8,7))
a1= fig1.add_subplot(111)

canvas1 = FigureCanvasTkAgg(fig1, master=affichage)
canvas1.show()
canvas1.get_tk_widget().grid(row = 1, column = 0, sticky = tk.W)

#toolbar = NavigationToolbar2TkAgg( canvas1, affichage )
#toolbar.update()
#canvas1._tkcanvas.grid(row=3, column=0, rowspan=20, columnspan = 30, sticky=W)


########################### fig2   #################

fig2 = plt.figure(2,figsize=(8,7))
a2= fig2.add_subplot(111)

canvas2 = FigureCanvasTkAgg(fig2, master=affichage)
canvas2.show()
canvas2.get_tk_widget().grid(row = 1, column = 1, sticky = tk.W)

#toolbar = NavigationToolbar2TkAgg( canvas2, affichage )
#toolbar.update()
#canvas2._tkcanvas.grid(row=3, column=1, rowspan=20, columnspan = 30, sticky=W)






racine.mainloop()
