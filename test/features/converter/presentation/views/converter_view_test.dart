import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:efg_converter/core/components/shared_widgets.dart';
import 'package:efg_converter/core/di/service_locator.dart';
import 'package:efg_converter/core/styles/light_theme.dart';
import 'package:efg_converter/features/converter/presentation/cubit/converter_cubit.dart';
import 'package:efg_converter/features/converter/presentation/views/converter_view.dart';
import 'package:efg_converter/features/converter/presentation/widgets/amount_card.dart';
import 'package:efg_converter/features/converter/presentation/widgets/exchange_panel.dart';
import 'package:efg_converter/features/converter/presentation/widgets/result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConverterCubit extends MockCubit<ConverterState>
    implements ConverterCubit {}

void main() {
  late MockConverterCubit mockCubit;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  });

  setUp(() async {
    mockCubit = MockConverterCubit();

    when(() => mockCubit.loadCurrencies()).thenAnswer((_) async {});
    when(() => mockCubit.close()).thenAnswer((_) async {});
    when(() => mockCubit.convert(
      amount: any(named: 'amount'),
      fromCurrency: any(named: 'fromCurrency'),
      toCurrency: any(named: 'toCurrency'),
    )).thenAnswer((_) async {});
    when(() => mockCubit.swapCurrencies(
      fromCurrency: any(named: 'fromCurrency'),
      toCurrency: any(named: 'toCurrency'),
    )).thenAnswer((_) {});

    await sl.reset();
    sl.registerFactory<ConverterCubit>(() => mockCubit);
  });

  tearDown(() async {
    await sl.reset();
  });

  Future<void> pumpConverterView(
      WidgetTester tester, {
        required ConverterState state,
      }) async {
    when(() => mockCubit.state).thenReturn(state);
    whenListen<ConverterState>(
      mockCubit,
      Stream<ConverterState>.fromIterable([state]),
      initialState: state,
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        saveLocale: false,
        child: Builder(
          builder: (context) => ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (_, __) => MaterialApp(
              theme: LightTheme.theme,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: const ConverterView(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows loading indicator while currencies are loading',
          (tester) async {
        await pumpConverterView(tester, state: CurrenciesLoading());

        expect(find.byType(LoadingWidget), findsOneWidget);
        expect(find.byType(ExchangePanel), findsNothing);
      });

  testWidgets('shows error state and retries on tap', (tester) async {
    await pumpConverterView(
      tester,
      state: ConverterError(message: 'Network error'),
    );
    clearInteractions(mockCubit);

    expect(find.byType(ErrorStateWidget), findsOneWidget);

    final errorWidget =
    tester.widget<ErrorStateWidget>(find.byType(ErrorStateWidget));
    errorWidget.onRetry();

    verify(() => mockCubit.loadCurrencies()).called(1);
  });

  testWidgets(
      'shows exchange panel, amount field and convert button when loaded',
          (tester) async {
        await pumpConverterView(
          tester,
          state: CurrenciesLoaded(
            currencies: {'USD': 'US Dollar', 'EUR': 'Euro'},
            selectedFrom: 'USD',
            selectedTo: 'EUR',
          ),
        );

        expect(find.byType(ExchangePanel), findsOneWidget);
        expect(find.byType(AmountCard), findsOneWidget);
        expect(find.byType(AppButton), findsOneWidget);
      });

  testWidgets('calls convert with entered amount and selected currencies',
          (tester) async {
        await pumpConverterView(
          tester,
          state: CurrenciesLoaded(
            currencies: {'USD': 'US Dollar', 'EUR': 'Euro'},
            selectedFrom: 'USD',
            selectedTo: 'EUR',
          ),
        );
        clearInteractions(mockCubit);

        await tester.enterText(find.byType(TextFormField), '100');
        await tester.tap(find.byType(AppButton));
        await tester.pumpAndSettle();

        verify(() => mockCubit.convert(
          amount: 100,
          fromCurrency: 'USD',
          toCurrency: 'EUR',
        )).called(1);
      });

  testWidgets('does not call convert when amount is empty', (tester) async {
    await pumpConverterView(
      tester,
      state: CurrenciesLoaded(
        currencies: {'USD': 'US Dollar', 'EUR': 'Euro'},
        selectedFrom: 'USD',
        selectedTo: 'EUR',
      ),
    );
    clearInteractions(mockCubit);

    await tester.tap(find.byType(AppButton));
    await tester.pumpAndSettle();

    verifyNever(() => mockCubit.convert(
      amount: any(named: 'amount'),
      fromCurrency: any(named: 'fromCurrency'),
      toCurrency: any(named: 'toCurrency'),
    ));
  });

  testWidgets('swap button calls swapCurrencies with current values',
          (tester) async {
        await pumpConverterView(
          tester,
          state: CurrenciesLoaded(
            currencies: {'USD': 'US Dollar', 'EUR': 'Euro'},
            selectedFrom: 'USD',
            selectedTo: 'EUR',
          ),
        );
        clearInteractions(mockCubit);

        await tester.tap(find.byIcon(Icons.swap_vert_rounded));
        await tester.pumpAndSettle();

        verify(() => mockCubit.swapCurrencies(
          fromCurrency: 'USD',
          toCurrency: 'EUR',
        )).called(1);
      });

  testWidgets('shows offline banner and result card on offline conversion',
          (tester) async {
        await pumpConverterView(
          tester,
          state: ConversionSuccess(
            currencies: {'USD': 'US Dollar', 'EUR': 'Euro'},
            amount: 100,
            fromCurrency: 'USD',
            toCurrency: 'EUR',
            result: 92.0,
            rate: 0.92,
            isOffline: true,
          ),
        );

        expect(find.byType(OfflineBanner), findsOneWidget);
        expect(find.byType(ResultCard), findsOneWidget);
      });
}