import flet as ft
import views.home_view as hv
import views.clients_view as cv


def main(page: ft.Page):
    #Page Setup
    page.bgcolor = ft.Colors.LIGHT_BLUE_50
    
    def route_change(e):
        # page.views.clear()

        if page.route == "/":
            page.views.append(hv.home_view(page))

        elif page.route == "/clients":
            page.views.append(cv.clients_view(page))

        page.update()

    page.on_route_change = route_change

    # Start at home
    page.go("/clients")


ft.app(main)
