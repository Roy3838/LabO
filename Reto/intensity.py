from manim import *
import numpy as np

class Stokes(Scene):
    def construct(self):
        def getelipse(S0,S1,S2,S3):
            p=np.sqrt(S1**2 + S2 ** 2 + S3**2)/S0
            chi=np.arcsin(S3/(p*S0))/2
            phi=np.arctan(S2/S1)/2
            a=np.sqrt(S0/(np.tan(chi)**2 + 1)   )
            b=a*np.tan(chi)
            return [a,b,phi]
        
        def make_elipse(a,b,phi,pol_angle, pos):
            malus = 0.8*np.cos(phi.get_value()-pol_angle.get_value())**2 + 0.2
            graph = ImplicitFunction(
            lambda x, y: x**2/a.get_value()**2 + y**2/b.get_value()**2 - 1,
            color=GOLD,
            # Ley de Malus
            stroke_opacity=malus
            ).rotate(phi.get_value()*180/PI).move_to(pos)
            graph.add_updater(lambda m: m.become(ImplicitFunction(
                lambda x, y: x**2/a.get_value()**2 + y**2/b.get_value()**2 - 1,
                color=GOLD,
                # Ley de Malus
                stroke_opacity=0.8*np.cos(phi.get_value()-pol_angle.get_value())**2 + 0.2
            ).rotate(phi.get_value()*180/PI).move_to(pos)
            ))
            print(malus)
            return graph
        
        
        elipses = VGroup()
        pol_angle = ValueTracker(0)
        for m in range(5):
            for i in range(5):
                elipse = make_elipse(ValueTracker(0.3),ValueTracker(0.01),ValueTracker(i/PI),pol_angle,RIGHT*i/3 + LEFT*5 + UP*m)
                elipses.add(elipse)
    
        self.add(elipses)
        self.add(elipses.copy().shift(UP*2))
        self.play(pol_angle.animate.set_value(PI/2), run_time= 0.2)
        #self.play(Create(elipses))
        #self.play(a.animate.set_value(1),b.animate.set_value(1),phi.animate.set_value(0))
        
            
            
            
        