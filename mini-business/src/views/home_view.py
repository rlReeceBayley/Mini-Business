import flet as ft

def build_home_view(page):
    #Page Title
    app_title = ft.Text("Mini-Business", size=50, data=0, font_family="Sans", weight=ft.FontWeight.W_600, text_align=ft.TextAlign.CENTER, color=ft.Colors.BLACK)
    company_title = ft.Text("Your Business Here", size=25, data=0, font_family="Sans", weight=ft.FontWeight.W_400, text_align=ft.TextAlign.CENTER, color=ft.Colors.GREY_700)

    title_sections = ft.Container(ft.Column(
        controls=[
            app_title,
            company_title
        ],
        spacing=0,
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER, height=175), alignment=ft.alignment.center, )

    #Quick Access Buttons
    invoice_button = ft.ElevatedButton("Invoice", bgcolor=ft.Colors.BLUE, color=ft.Colors.WHITE, icon=ft.Icons.DESCRIPTION, icon_color=ft.Colors.WHITE, width=200, height=75, style=ft.ButtonStyle(shape=ft.RoundedRectangleBorder(radius=10), shadow_color=ft.Colors.BLUE_200, elevation=5, padding=ft.Padding(10, 10, 10, 10)))
    quote_button = ft.ElevatedButton("Quote", bgcolor=ft.Colors.GREEN, color=ft.Colors.WHITE, icon=ft.Icons.RECEIPT, icon_color=ft.Colors.WHITE, width=200, height=75,  style=ft.ButtonStyle(shape=ft.RoundedRectangleBorder(radius=10), shadow_color=ft.Colors.BLUE_200, elevation=5, padding=ft.Padding(10, 10, 10, 10)))
    stock_button = ft.ElevatedButton("Stock", bgcolor=ft.Colors.PURPLE, color=ft.Colors.WHITE, icon=ft.Icons.STORAGE, icon_color=ft.Colors.WHITE, width=200, height=75,  style=ft.ButtonStyle(shape=ft.RoundedRectangleBorder(radius=10), shadow_color=ft.Colors.BLUE_200, elevation=5, padding=ft.Padding(10, 10, 10, 10)))
    credit_button = ft.ElevatedButton("Credits", bgcolor=ft.Colors.PURPLE_900, color=ft.Colors.WHITE, icon=ft.Icons.CREDIT_CARD, icon_color=ft.Colors.WHITE, width=200, height=75,  style=ft.ButtonStyle(shape=ft.RoundedRectangleBorder(radius=10), shadow_color=ft.Colors.BLUE_200, elevation=5, padding=ft.Padding(10, 10, 10, 10)))

    quick_buttons = ft.Row(
        controls=[
            invoice_button,
            quote_button,
            stock_button,
            credit_button
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        spacing=50,
    )
    #Recent Sales Section
    top_section = ft.Row([
        ft.Text("Recent Sales", size=25, data=0, text_align=ft.TextAlign.LEFT, color=ft.Colors.BLACK),
        ft.TextField("Search Sales", width=300, height=40, icon=ft.Icons.SEARCH, text_align=ft.TextAlign.LEFT, border_radius=5),
    ],
            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
            vertical_alignment=ft.CrossAxisAlignment.CENTER,          
            )

    recent_sales_list = ft.ListView(
        controls=[
            ft.ListTile(title=ft.Text("Sale 1"), subtitle=ft.Text("Details of Sale 1"), bgcolor=ft.Colors.GREY_50),
            ft.ListTile(title=ft.Text("Sale 2"), subtitle=ft.Text("Details of Sale 2"), bgcolor=ft.Colors.GREY_50),
            ft.ListTile(title=ft.Text("Sale 3"), subtitle=ft.Text("Details of Sale 3"), bgcolor=ft.Colors.GREY_50),
            ft.ListTile(title=ft.Text("Sale 4"), subtitle=ft.Text("Details of Sale 4"), bgcolor=ft.Colors.GREY_50)],
            spacing=10,
            expand=True,)

    recent_sales_section = ft.Container(ft.Column(
        controls=[
            top_section,
            ft.Divider(),
            recent_sales_list
        ],), bgcolor=ft.Colors.WHITE, alignment=ft.alignment.center,border_radius=10, expand=True, padding=ft.Padding(20, 20, 20, 20), margin=ft.Margin(20, 20, 20, 20))

    menu_button = ft.FloatingActionButton(
        icon=ft.Icons.MENU,  on_click=lambda _: page.go("/clients"), 
    )

    return title_sections, quick_buttons, recent_sales_section, menu_button

def home_view(page: ft.Page):
    return ft.View(
        "/",
        build_home_view(page),
    )