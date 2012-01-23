
package m.mvc.base;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import m.inject.IInjector;
import m.inject.Injector;
import m.inject.Reflector;
import m.mvc.api.IMediator;
import m.mvc.api.IMediatorMap;
import m.inject.IReflector;
import m.mvc.api.IViewContainer;
import m.mvc.impl.support.TestContextView;
import m.mvc.impl.support.TestContextViewMediator;
import m.mvc.impl.support.ViewComponent;
import m.mvc.impl.support.ViewComponentAdvanced;
import m.mvc.impl.support.ViewMediator;
import m.mvc.impl.support.ViewMediatorAdvanced;

class MediatorMapTest
 {
	public function new() { }
	
	var contextView:TestContextView;
	var commandExecuted:Bool;
	var mediatorMap:MediatorMap;
	var injector:IInjector;
	var reflector:IReflector;
	
	@Before
	public function before():Void
	{
		contextView = new TestContextView();
		injector = new Injector();
		reflector = new Reflector();
		mediatorMap = new MediatorMap(contextView, injector, reflector);
		
		injector.mapValue(IViewContainer, contextView);
		injector.mapValue(IInjector, injector);
		injector.mapValue(IMediatorMap, mediatorMap);
	}
	
	@After
	public function after():Void
	{
		injector.unmap(IMediatorMap);
	}
	/*
	@Test
	public function mediatorIsMappedAndCreatedForView():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator = mediatorMap.createMediator(viewComponent);
		var hasMapping = mediatorMap.hasMapping(ViewComponent);
		
		Assert.isTrue(hasMapping);//'View mapping should exist for View Component'
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsClass():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent, false, false);
		
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(Std.is(mediator, ViewMediator));//'Mediator should have been created of the exact desired class'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		Assert.isNotNull(exactMediator.view);//'View Component should have been injected into Mediator'
		Assert.isTrue(Std.is(exactMediator.view, ViewComponent));//'View Component injected should match the desired class type'
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfSameClass():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent], false, false);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		var exactMediator:ViewMediator = cast( mediator, ViewMediator);
		
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(Std.is(mediator, ViewMediator));//'Mediator should have been created of the exact desired class'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		Assert.isNotNull(exactMediator.view);//'View Component should have been injected into Mediator'
		Assert.isTrue(Std.is(exactMediator.view, ViewComponent));//'View Component injected should match the desired class type'
	}
	
	@Test
	public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfRelatedClass():Void
	{
		mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced], false, false);
		
		var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
		contextView.addView(viewComponentAdvanced);

		var mediator:IMediator = mediatorMap.createMediator(viewComponentAdvanced);
		var exactMediator:ViewMediatorAdvanced = cast( mediator, ViewMediatorAdvanced);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(Std.is(mediator, ViewMediatorAdvanced));//'Mediator should have been created of the exact desired class'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponentAdvanced));//'Mediator should have been created for View Component'
		Assert.isNotNull(exactMediator.view);//'First Class in the "injectViewAs" array should have been injected into Mediator'
		Assert.isNotNull(exactMediator.viewAdvanced);//'Second Class in the "injectViewAs" array should have been injected into Mediator'
		Assert.isTrue(Std.is(exactMediator.view, ViewComponent));//'First Class injected via the "injectViewAs" array should match the desired class type'
		Assert.isTrue(Std.is(exactMediator.viewAdvanced, ViewComponentAdvanced));//'Second Class injected via the "injectViewAs" array should match the desired class type'
	}
	
	@Test
	public function mediatorIsMappedAddedAndRemoved():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addView(viewComponent);

		var mediator:IMediator = mediatorMap.createMediator(viewComponent);
		
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		
		mediatorMap.removeMediator(mediator);
		
		Assert.isFalse(mediatorMap.hasMediator(mediator));//"Mediator Should Not Exist"
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator Should Not Exist"
	}
	
	@Test
	public function mediatorIsMappedAddedAndRemovedByView():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
		contextView.addView(viewComponent);
		
		var mediator:IMediator = mediatorMap.createMediator(viewComponent);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
		
		mediatorMap.removeMediatorByView(viewComponent);
		
		Assert.isFalse(mediatorMap.hasMediator(mediator));//"Mediator should not exist"
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator should not exist"
	}
	
	@Test
	public function autoRegister():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}
	
	@Test
	public function mediatorIsKeptDuringReparentingPreconditions():Void
	{
		var viewComponent = new ViewComponent();
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addView(viewComponent);
		
		var mediator = mediatorMap.createMediator(viewComponent);
		
		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}

	// @AsyncTest
	// public function mediatorIsKeptDuringReparenting(factory:AsyncFactory):Void
	// {
	// 	var viewComponent = new ViewComponent();
		
	// 	mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
	// 	contextView.addView(viewComponent);
		
	// 	var mediator = mediatorMap.createMediator(viewComponent);
		
	// 	contextView.removeView(viewComponent);
	// 	contextView.addView(viewComponent);
		
	// 	var data = {view:viewComponent, mediator: mediator};
	// 	var handler = factory.createHandler(this, callback(verifyMediatorSurvival, data), 300);
	// 	haxe.Timer.delay(handler, 200);
	// }
	
	// function verifyMediatorSurvival(data:Dynamic):Void
	// {
	// 	var viewComponent:ViewComponent = data.view;
	// 	var mediator:IMediator = data.mediator;

	// 	Assert.isTrue(mediatorMap.hasMediator(mediator));//"Mediator should exist"
	// 	Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator should exist"
	// }
	
	public function mediatorIsRemovedWithViewPreconditions():Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addView(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);

		Assert.isNotNull(mediator);//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediator(mediator));//'Mediator should have been created'
		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}

	@AsyncTest
	public function mediatorIsRemovedWithView(factory:AsyncFactory):Void
	{
		var viewComponent:ViewComponent = new ViewComponent();
		var mediator:IMediator;
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		contextView.addView(viewComponent);
		mediator = mediatorMap.createMediator(viewComponent);
		
		contextView.removeView(viewComponent);
		
		var data = {view: viewComponent, mediator: mediator};
		var handler = factory.createHandler(this, callback(verifyMediatorRemoval, data), 300);
		haxe.Timer.delay(handler, 200);
	}
	
	function verifyMediatorRemoval(data:Dynamic):Void
	{
		var viewComponent:ViewComponent = data.view;
		var mediator:IMediator = data.mediator;

		Assert.isFalse(mediatorMap.hasMediator(mediator));//"Mediator should not exist"
		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//"View Mediator should not exist"
	}
	
	@Test
	public function contextViewMediatorIsCreatedWhenMapped():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator );
		Assert.isTrue(mediatorMap.hasMediatorForView(contextView));//'Mediator should have been created for contextView'
	}
	
	@Test
	public function contextViewMediatorIsNotCreatedWhenMappedAndAutoCreateIsFalse():Void
	{
		mediatorMap.mapView( TestContextView, TestContextViewMediator, null, false );
		Assert.isFalse(mediatorMap.hasMediatorForView(contextView));//'Mediator should NOT have been created for contextView'
	}
	
	@Test
	public function unmapView():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator);
		mediatorMap.unmapView(ViewComponent);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);
		
		var hasMediator = mediatorMap.hasMediatorForView(viewComponent);
		var hasMapping = mediatorMap.hasMapping(ViewComponent);

		Assert.isFalse(hasMediator);//'Mediator should NOT have been created for View Component'
		Assert.isFalse(hasMapping);//'View mapping should NOT exist for View Component'
	}
	
	@Test
	public function autoRegisterUnregisterRegister():Void
	{
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		mediatorMap.unmapView(ViewComponent);

		var viewComponent = new ViewComponent();
		contextView.addView(viewComponent);

		Assert.isFalse(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should NOT have been created for View Component'
		contextView.removeView(viewComponent);
		
		mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
		contextView.addView(viewComponent);

		Assert.isTrue(mediatorMap.hasMediatorForView(viewComponent));//'Mediator should have been created for View Component'
	}
	*/
}