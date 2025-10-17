import flet as ft

def build_client_view(page):
    # Page Title
    clients_title = ft.Text("Clients", size=40, data=0, font_family="Sans", weight=ft.FontWeight.W_600, text_align=ft.TextAlign.LEFT, color=ft.Colors.BLACK)
    clients_subtitle = ft.Text("Manage your clients here", size=20, data=0, font_family="Sans", weight=ft.FontWeight.W_400, text_align=ft.TextAlign.LEFT, color=ft.Colors.GREY_700)

    title_section = ft.Container(ft.Column(
        controls=[
            clients_title,
            clients_subtitle
        ],
        spacing=5,
        alignment=ft.MainAxisAlignment.START,
        horizontal_alignment=ft.CrossAxisAlignment.START, height=100), alignment=ft.alignment.top_left, )
    
    client_list = ft.Column(
        controls=[
            ft.Row([ft.Text("Client Name", weight=ft.FontWeight.W_600, size=18), ft.TextField(icon=ft.Icons.SEARCH, border_radius=50, hint_text="Search")], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
            ft.ListTile(title=ft.Text("Client 1"), subtitle=ft.Text("Details of Client 1"), bgcolor=ft.Colors.GREY_50),
            ft.ListTile(title=ft.Text("Client 2"), subtitle=ft.Text("Details of Client 2"), bgcolor=ft.Colors.GREY_50),
            ft.ListTile(title=ft.Text("Client 3"), subtitle=ft.Text("Details of Client 3"), bgcolor=ft.Colors.GREY_50),
            ft.ListTile(title=ft.Text("Client 4"), subtitle=ft.Text("Details of Client 4"), bgcolor=ft.Colors.GREY_50)],
            spacing=10,
            expand=True,)
    
    client_section = ft.Container(ft.Column(
        controls=[
            client_list
        ],), bgcolor=ft.Colors.WHITE, alignment=ft.alignment.center,border_radius=10, expand=True, padding=ft.Padding(20, 20, 20, 20), margin=ft.Margin(20, 20, 20, 20))
    
    return_button = ft.ElevatedButton("Back Home", on_click=lambda _: page.go("/"))
    return return_button, title_section, client_section

def clients_view(page):
    return ft.View(
        "/clients",
        build_client_view(page)
    )