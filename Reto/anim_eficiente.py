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
            def intensity_updater(mobject):
                mobject.set_stroke(opacity=(0.95*np.cos(2*phi.get_value()-2*pol_angle.get_value())**2) + 0.05)
            malus =(0.95*np.cos(2*phi.get_value()-2*pol_angle.get_value())**2) + 0.05
            graph = ImplicitFunction(
            lambda x, y: x**2/a.get_value()**2 + y**2/b.get_value()**2 - 1,
            color="#525893",
            # Ley de Malus
            stroke_opacity=malus
            ).rotate(phi.get_value()*180/PI).move_to(pos)
            graph.add_updater(intensity_updater)
            return graph
        
        
        
        #phi = ValueTracker(0)
        elipses = VGroup()
        pol_angle = ValueTracker(0)
        for m in range(12):
            for i in range(25):
                #phi = ValueTracker(i/PI)
                pos =  RIGHT*i/2 + LEFT*6 + UP*m/2 + DOWN*3.5
                elipse = make_elipse(ValueTracker(0.23),ValueTracker(0.01), ValueTracker(0.5*i/PI), pol_angle, pos)
                #elipse.add_updater(intensity_updater, phi)
                elipses.add(elipse)
                
    
        arrow = Arrow(UP*3+ LEFT, UP*3 + RIGHT).set_color(BLACK)
        arrow.add_updater(lambda m: m.become(Arrow(UP*3+ LEFT, UP*3 + RIGHT).set_color(BLACK).rotate(-2*pol_angle.get_value())))


        self.play(Create(elipses), run_time= 2)
        self.play(Create(arrow))
        self.play(pol_angle.animate.set_value(PI/8), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(PI/4), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(3*PI/8), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(PI/2), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(5*PI/8), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(3*PI/4), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(7*PI/8), run_time= 1.5)
        self.wait(0.5)
        self.play(pol_angle.animate.set_value(PI), run_time= 1.5)
        
        self.wait()
        self.play(pol_angle.animate.set_value(0), run_time= 2.5)
        self.wait(2)