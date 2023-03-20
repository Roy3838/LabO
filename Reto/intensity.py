from manim import *
import numpy as np

class Stokes(Scene):
    def construct(self):
        # Background color
        self.camera.background_color = "#E2E2E2"
        

        def getelipse(S0,S1,S2,S3):
            p=np.sqrt(S1**2 + S2 ** 2 + S3**2)/S0
            chi=np.arcsin(S3/(p*S0))/2
            phi=np.arctan(S2/S1)/2
            a=np.sqrt(S0/(np.tan(chi)**2 + 1)   )
            b=a*np.tan(chi)
            return [a,b,phi]
        
        def make_elipse(a,b,phi,pol_angle, pos):
            malus = 0.9*np.cos(2*phi.get_value()-2*pol_angle.get_value())**2 + 0.1
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
                stroke_opacity=0.8*np.cos(2*phi.get_value()-2*pol_angle.get_value())**2 + 0.2
            ).rotate(phi.get_value()*180/PI).move_to(pos)
            ))
            return graph
        
        
        
        
        elipses = VGroup()
        pol_angle = ValueTracker(0)
        for m in range(5):
            for i in range(15):
                elipse = make_elipse(ValueTracker(0.3),ValueTracker(0.01),ValueTracker(i/PI),pol_angle,RIGHT*i/1.3 + LEFT*5 + UP*m/1.4 + DOWN*2)
                elipses.add(elipse)
    
        arrow = Arrow(UP*3+ LEFT, UP*3 + RIGHT).set_color(BLACK)
        arrow.add_updater(lambda m: m.become(Arrow(UP*3+ LEFT, UP*3 + RIGHT).set_color(BLACK).rotate(2*pol_angle.get_value())))


        self.play(Create(elipses))
        self.play(Create(arrow))
        self.play(pol_angle.animate.set_value(PI/8), run_time= 1)
        self.wait()
        self.play(pol_angle.animate.set_value(PI/4), run_time= 1)
        self.wait()
        self.play(pol_angle.animate.set_value(3*PI/8), run_time= 1)
        self.wait()
        self.play(pol_angle.animate.set_value(PI/2), run_time= 1)
        #self.play(pol_angle.animate.set_value(3*PI), run_time= 8, rate_func=linear)
        self.wait()
        self.play(pol_angle.animate.set_value(0), run_time= 1.5)
        

        #self.play(Create(elipses))
        #self.play(a.animate.set_value(1),b.animate.set_value(1),phi.animate.set_value(0))
        
            
            
            
        